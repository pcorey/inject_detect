import React from "react";
import _ from "lodash";

class ApplicationAlerting extends React.Component {

    toggleAlerting(e) {
        e.preventDefault();
    }

    render() {
        let { application } = this.props;

        return (
            <div className="ui field">
                <div className="ui toggle checkbox">
                    <input type="checkbox" ref="alerting" checked={application.alerting} onChange={this.toggleAlerting.bind(this)}/>
                    <label>Sending email alerts</label>
                </div>
            </div>
        );
    }

};

export default ApplicationAlerting;
