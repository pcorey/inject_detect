import React from "react";
import _ from "lodash";
import { ApplicationQuery } from "../graphql";
import { graphql } from "react-apollo";

import ApplicationSecret from "./ApplicationSecret";
import ExpectedQueries from "./ExpectedQueries";
import UnexpectedQueries from "./UnexpectedQueries";

class Application extends React.Component {

    toggleTrainingMode(e) {
        console.log("toggle training mode")
        e.preventDefault();
    }

    toggleAlerting(e) {
        e.preventDefault();
    }

    render() {
        let { application, loading } = this.props.data;
        console.log(application)
        if (!application) {
            return null;
        }

        if (loading) {
            return (
                <div>Loading...</div>
            );
        }
        else if (application) {
            return (
                <div className="ij-dashboard ui mobile reversed stackable grid">

                    <div className="sixteen wide column">
                        <h1 style={{fontSize: "3em", fontWeight: 100}}>{application.name}</h1>
                        <div className="ui segment">
                            <h3>Application Configuration</h3>
                            <div className="ui form">
                                <div className="ui field">
                                    <div className="ui labeled input">
                                        <div className="ui label">
                                            Secret token:
                                        </div>
                                        <input type="text" value={application.token}/>
                                    </div>
                                </div>
                                <div className="ui field">
                                    <div className="ui toggle checkbox">
                                        <input type="checkbox" ref="trainingMode" checked={application.trainingMode} onChange={this.toggleTrainingMode.bind(this)}/>
                                        <label>In training mode</label>
                                    </div>
                                </div>
                                <div className="ui field">
                                    <div className="ui toggle checkbox">
                                        <input type="checkbox" ref="alerting" checked={application.alerting} onChange={this.toggleAlerting.bind(this)}/>
                                        <label>Sending email alerts</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div className="ui segment">
                            <h3>Unexpected queries:</h3>
                            <UnexpectedQueries application={application}/>
                        </div>

                        <div className="ui segment">
                            <h3>Expected queries:</h3>
                            <ExpectedQueries application={application}/>
                        </div>

                    </div>

                </div>
            );
        }
        else {
            return (
                <div>Application not found...</div>
            );
        }
    }
};

export default graphql(ApplicationQuery, {
    options: props => ({
        variables: {
            id: _.get(props, "match.params.id")
        }
    })
})(Application);
