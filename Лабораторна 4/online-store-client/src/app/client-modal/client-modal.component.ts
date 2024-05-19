import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-client-modal',
  templateUrl: './client-modal.component.html',
  styleUrls: ['./client-modal.component.css']
})
export class ClientModalComponent {
  @Input() client: any;
  @Input() isEditMode: boolean = false;
  @Output() save = new EventEmitter<void>();
  @Output() close = new EventEmitter<void>();

  saveClient(): void {
    this.save.emit();
  }

  closeModal(): void {
    this.close.emit();
  }
}