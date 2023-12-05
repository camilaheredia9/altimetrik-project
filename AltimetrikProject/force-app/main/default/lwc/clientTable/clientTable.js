import { LightningElement, wire } from 'lwc';
import getClients from '@salesforce/apex/ucl_clientsController.getClients';

const columns = [
    { label: 'Legal Advisor - Account Number', fieldName: 'AccountNumber', type: 'text' },
    { labal: 'Legal Advisor Name', fieldName: 'AccountName', type: 'text' },
    { label: 'Amount of Clients', fieldName: 'expr0', type: 'number' },
];

export default class clientTable extends LightningElement {
    columns = columns;

    @wire(getClients)

    clients;
}