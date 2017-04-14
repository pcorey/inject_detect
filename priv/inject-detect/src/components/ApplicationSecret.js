import React from "react";
import _ from "lodash";

class ApplicationSecret extends React.Component {

    render() {
        let { application } = this.props;

        return (
            <div className="ui field">
                <div className="ui labeled input">
                    <div className="ui label">
                        Secret token:
                    </div>
                    <input type="text" value={application.token}/>
                </div>
            </div>
        );
    }

};

export default ApplicationSecret;
