import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Chart, registerables } from 'chart.js';

@Component({
  selector: 'app-orders-chart',
  templateUrl: './orders-chart.component.html',
  styleUrls: ['./orders-chart.component.css']
})
export class OrdersChartComponent implements OnInit {

  @Output() close = new EventEmitter<void>();

  constructor(private http: HttpClient) {
    Chart.register(...registerables);
  }

  ngOnInit(): void {
    this.loadChart();
  }

  loadChart(): void {
    this.http.get<any[]>('http://localhost:3001/orders').subscribe(data => {
      const statuses = data.map(order => order.status);
      const uniqueStatuses = Array.from(new Set(statuses));
      const statusCounts = uniqueStatuses.map(status => statuses.filter(s => s === status).length);

      const ctx = document.getElementById('ordersChart') as HTMLCanvasElement;
      new Chart(ctx, {
        type: 'bar',
        data: {
          labels: uniqueStatuses,
          datasets: [{
            label: 'Status of Orders',
            data: statusCounts,
            backgroundColor: 'rgba(54, 162, 235, 0.2)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
          }]
        },
        options: {
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      });
    });
}

  closeModal(): void {
    this.close.emit();
  }
}
