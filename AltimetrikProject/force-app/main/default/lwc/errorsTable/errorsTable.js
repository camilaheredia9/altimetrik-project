import { LightningElement, wire } from 'lwc';
import getErrors from '@salesforce/apex/ucl_errorsController.getErrors';

const columns = [
    { label: 'ID', fieldName: 'Id', type: 'text' },
    { label: 'Error Message', fieldName: 'Error_Message__c', type: 'text' },
];

export default class errorsTable extends LightningElement {
    columns = columns;

    @wire(getErrors)

    errors;
}