import React from "react";
import _ from "lodash";
import { ApplicationQuery } from "../graphql";
import { Link } from "react-router-dom";
import { graphql } from "react-apollo";

import ApplicationAlerting from "./ApplicationAlerting";
import ApplicationSecret from "./ApplicationSecret";
import ApplicationTrainingMode from "./ApplicationTrainingMode";
import ExpectedQueries from "./ExpectedQueries";
import UnexpectedQueries from "./UnexpectedQueries";

class Application extends React.Component {

    render() {
        let { application, loading } = this.props.data;

        if (!application) {
            return null;
        }

        if (loading) {
            return (
                <div className="ui active loader"></div>
            );
        }
        else if (application) {
            return (
                <div className="ij-application ui mobile reversed stackable grid">

                    <div className="sixteen wide column">
                        <h1 className="ui header">
                            Application: {application.name}
                        </h1>


                        {/* <div className="ui segment">
                            <h3 className="ui sub header">Application Configuration</h3>
                            <div className="ui form">
                            <ApplicationSecret application={application}/>
                            <ApplicationTrainingMode application={application}/>
                            <ApplicationAlerting application={application}/>
                            </div>
                            </div> */}

                        <div className="section">
                            <h3 className="ui sub header">Expected queries:</h3>
                            <div className="ui grid">
                                <div className="fourteen wide column">
                                    <p className="instructions">
                                        We've detected {application.unexpectedQueries.length} unexpected queries made against this application. If any of the queries below seem suspicious, they may be the result of a NoSQL Injection attack. Use <Link to="/">our guides and suggestions</Link> to track down and fix any queries in your application that may be vulnerable to NoSQL Injection attacks.
                                    </p>
                                </div>
                                <div className="two wide column graphic container">
                                    <i className="ui warning graphic icon"/>
                                </div>
                            </div>
                            <UnexpectedQueries application={application}/>
                        </div>

                        {/* <div className="ui icon message">
                            <i className="inbox icon"></i>
                            <div className="content">
                            <div className="header">
                            Have you heard about our mailing list?
                            </div>
                            <p>Get the best news in your e-mail every day.</p>
                            </div>
                            </div> */}

                        <div className="section">
                            <h3 className="ui sub header">Unexpected queries:</h3>
                            <p className="instructions">
                                Your application is expecting {application.expectedQueries.length} {application.expectedQueries.length == 1 ? "type of query" : "different queries"}. Add more queries by setting your application into <code>Training Mode</code>, or marking unexpected queries as expected.
                            </p>
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
