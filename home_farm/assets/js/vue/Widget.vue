<template>
  <div>
    <div class="card mb-3" v-for="sensor in sensors">
      <div class="card-header">{{ sensor.name }}</div>
      <div class="card-body">
        <canvas :id="'sensorChart' + sensor.id" width="400" height="200"></canvas>
      </div>
    </div>
  </div>
</template>

<script>
import Axios from "axios"
import Chart from "chart.js"

export default {
  data() {
    return {
      sensors: []
    }
  },
  methods: {
    getSensors: function() {
      Axios.get("/api/sensors")
      .then((response) => {
        this.sensors = response.data.sensors
        this.sensors.forEach((sensor) => {
          setTimeout(() => {
            this.plotChart(sensor)
          }, 2000)
        })
      })
      .catch((error) => {
        console.log(error)
      }) 
    },
    plotChart: function (sensor) {
      const ctx = document.getElementById('sensorChart' + sensor.id).getContext('2d');
      new Chart(ctx, {
        type: 'line',
        data:  {
          datasets: [{
            label: sensor.name,
            data: sensor.readings
          }]
        },
        options: {
          scales: {
            xAxes: [{
              type: 'time',
              time: {
                unit: 'hour'
              }
            }]
          }
        }
      })
    }
  },
  created () {
    this.getSensors()
  }
}
</script>
