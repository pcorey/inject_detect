import React from "react";
import _ from "lodash";
import { ApplicationQuery } from "../graphql";
import { graphql } from "react-apollo";

import ApplicationAlerting from "./ApplicationAlerting";
import ApplicationSecret from "./ApplicationSecret";
import ApplicationTrainingMode from "./ApplicationTrainingMode";
import ExpectedQueries from "./ExpectedQueries";
import UnexpectedQueries from "./UnexpectedQueries";

class Application extends React.Component {

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
                                <ApplicationSecret application={application}/>
                                <ApplicationTrainingMode application={application}/>
                                <ApplicationAlerting application={application}/>
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
        },
        pollInterval: 5000
    })
})(Application);
