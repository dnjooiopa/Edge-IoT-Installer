require('dotenv').config();
const fs = require('fs');
const path = require('path');

const MQTT = require('mqtt');

const devices = require('./devices.json');
const mqttUsers = [{
  username: process.env.MQTT1_REALTIME_USERNAME,
  password: process.env.MQTT1_REALTIME_PASSWORD
},
{
  username: process.env.MQTT2_REALTIME_USERNAME,
  password: process.env.MQTT2_REALTIME_PASSWORD
}];

function runRealtime(device, mqttClient) {

  const KEY = fs.readFileSync(path.join(__dirname, 'certificates', device.device_id, `${device.device_id}.key`)).toString();
  const CERT = fs.readFileSync(path.join(__dirname, 'certificates', device.device_id, `${device.device_id}.pem`)).toString();
  const CA = [fs.readFileSync(path.join(__dirname, 'certificates', 'ca.pem')).toString()];

  const options = {
    host: process.env.MQTT_HOST,
    username: mqttClient.username,
    password: mqttClient.password,
    port: process.env.MQTT_PORT,
    protocol: 'mqtts',
    ca: CA,
    key: KEY,
    cert: CERT,
    rejectUnauthorized: true
  };

  console.log(options);

  const client = MQTT.connect(options);

  client.on('connect', () => {
    console.log('🟢 RTU realtime connected');

    const requestTopic = `iot/${device.location_name}/${device.device_id}/info/request`;
    const responseTopic = `iot/${device.location_name}/${device.device_id}/info/response`;

    client.publish(responseTopic, JSON.stringify(device));

    client.subscribe(requestTopic, (err) => {
      if (err) {
        return console.log(`🔴 Cannot subscribe to ${requestTopic}`);
      }
    });

    client.on('message', (topic, payload) => {
      client.publish(responseTopic, JSON.stringify(device));
    });
  });

  client.on('error', (err) => {
    console.log(err.message);
  });

  const realtimeTopic = `iot/${device.location_name}/${device.device_id}/value`;
  setInterval(() => {
    if (client.connected) {
      const elements = device.elements.map((e) => ({
        element_id: e.element_id,
        value: (Math.random() * 100).toFixed(2),
      }));

      const payload = {
        timestamp: Number.parseInt(new Date().getTime() / 1000),
        device_id: device.device_id,
        firmware_version: '3.11.11',
        operation_time_since: 1614335879,
        elements: elements,
      };
      console.log('==== publishing ====');
      console.log(payload);
      client.publish(realtimeTopic, JSON.stringify(payload));
    }
  }, 3000);
}

for (const index in devices) {
  runRealtime(devices[index], mqttUsers[index]);
}