import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCalloutOnDemand from '@salesforce/apex/ucl_getCalloutOnDemand.getCalloutOnDemand';

export default class ButtonIntegration extends LightningElement {
    @wire(getCalloutOnDemand)
    response;

    handleClick(){
        let tt;
        let msg;
        let vt;

        if (this.response.data) {
            tt = 'You have activated the integration service.';
            if (this.response.data == 200) {
                msg = `HTTP request successfully completed.`;
                vt = 'success';
            } else {
                msg = `Error in HTTP response. Status code: ${this.response.data}`;
                vt = 'error';
            }
        } else if (this.response.error) {
            tt = 'We could not activate the integration service.';
            msg = `Error: ${this.response.error.body.message}`;
            vt = 'error';
        }

        // display a toast message:
        const evt = new ShowToastEvent({
            title: tt,
            message: msg,
            variant: vt,
          });
          this.dispatchEvent(evt);
    }
}