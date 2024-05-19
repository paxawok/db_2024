import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { ClientsComponent } from './clients/clients.component';
import { OrdersChartComponent } from './orders-chart/orders-chart.component';

const routes: Routes = [
  { path: 'clients', component: ClientsComponent },
  { path: 'orders-chart', component: OrdersChartComponent },
  { path: '', redirectTo: '/clients', pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }