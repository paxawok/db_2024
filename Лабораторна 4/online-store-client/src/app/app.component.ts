// src/app/app.component.ts
import { Component, OnInit } from '@angular/core';
import { ClientService } from './client.service';

interface Client {
  id: number;
  name: string;
  address: string;
  email: string;
  phone: string;
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'online-store-client';
  clients: Client[] = [];
  filteredClients: Client[] = [];
  searchText: string = '';
  newClient: Client = { id: 0, name: '', address: '', email: '', phone: '' };
  selectedClient: Client | null = null;
  isEditMode: boolean = false;
  sortOrder: boolean = true;

  constructor(private clientService: ClientService) {}

  ngOnInit(): void {
    this.loadAllClients();
  }

  loadAllClients(): void {
    this.clientService.getClients().subscribe(clients => {
      console.log("Clients loaded:", clients);
      this.clients = clients;
      this.filteredClients = clients;
    });
  }

  addClient(): void {
    this.newClient.id = this.generateClientId();
    this.clientService.addClient(this.newClient).subscribe(client => {
      console.log("Client added:", client);
      this.clients.push(client);
      this.filteredClients.push(client);
      this.newClient = { id: 0, name: '', address: '', email: '', phone: '' };
    });
  }

  generateClientId(): number {
    const prefix = 12300000;
    const randomId = Math.floor(Math.random() * 90000) + 10000;
    return prefix + randomId;
  }

  searchClients(): void {
    if (this.searchText === '') {
      this.filteredClients = this.clients;
    } else {
      this.filteredClients = this.clients.filter(client =>
        client.name.toLowerCase().includes(this.searchText.toLowerCase())
      );
    }
  }

  sortClients(): void {
    this.sortOrder = !this.sortOrder;
    this.filteredClients.sort((a, b) => {
      if (a.name < b.name) {
        return this.sortOrder ? -1 : 1;
      } else if (a.name > b.name) {
        return this.sortOrder ? 1 : -1;
      } else {
        return 0;
      }
    });
  }

  viewClient(client: Client): void {
    this.selectedClient = client;
    this.isEditMode = false;
    console.log("View client:", client);
  }

  editClient(client: Client): void {
    this.selectedClient = { ...client };
    this.isEditMode = true;
    console.log("Edit client:", client);
  }

  saveClient(): void {
    if (this.selectedClient) {
      this.clientService.updateClient(this.selectedClient).subscribe(updatedClient => {
        console.log("Client updated:", updatedClient);
        const index = this.clients.findIndex(c => c.id === updatedClient.id);
        if (index !== -1) {
          this.clients[index] = updatedClient;
          this.filteredClients[index] = updatedClient;
        }
        this.selectedClient = null;
      });
    }
  }

  deleteClient(id: number): void {
    this.clientService.deleteClient(id).subscribe(() => {
      console.log("Client deleted:", id);
      this.clients = this.clients.filter(client => client.id !== id);
      this.filteredClients = this.filteredClients.filter(client => client.id !== id);
    });
  }

  closeModal(): void {
    this.selectedClient = null;
  }
}
