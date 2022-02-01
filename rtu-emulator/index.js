require('dotenv').config();

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
const mqttMetas = [{
  username: process.env.MQTT1_META_USERNAME,
  password: process.env.MQTT1_META_PASSWORD
},
{
  username: process.env.MQTT2_META_USERNAME,
  password: process.env.MQTT2_META_PASSWORD
}];

function runMetaData(device, mqttClient) {
  const client = MQTT.connect({
    host: process.env.MQTT_HOST,
    username: mqttClient.username,
    password: mqttClient.password,
    port: process.env.MQTT_PORT,
    protocol: 'mqtt',
  });

  client.on('connect', () => {
    console.log('🟢 RTU meta data connected');
    const requestTopic = `iot/${device.location_name}/${device.device_id}/info/request`;
    client.subscribe(requestTopic, (err) => {
      if (err) {
        return console.log(`🔴 Cannot subscribe to ${requestTopic}`);
      }
    });

    const responseTopic = `iot/${device.location_name}/${device.device_id}/info/response`;

    client.on('message', (topic, payload) => {
      client.publish(responseTopic, JSON.stringify(device));
    });
  });
}

function runRealtime(device, mqttClient) {
  const client = MQTT.connect({
    host: process.env.MQTT_HOST,
    username: mqttClient.username,
    password: mqttClient.password,
    port: process.env.MQTT_PORT,
    protocol: 'mqtt',
  });

  client.on('connect', () => {
    console.log('🟢 RTU realtime connected');
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
  runMetaData(devices[index], mqttMetas[index]);
  runRealtime(devices[index], mqttUsers[index]);
}

