import Moment from 'react-moment';
import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { Link } from "react-router-dom";
import { commas } from "./pretty";
import { graphql } from "react-apollo";

class Dashboard extends React.Component {

    initProgress() {
        window.$('.ui.progress').progress();
    }

    componentDidMount() {
        this.initProgress();
    }

    componentDidUpdate() {
        this.initProgress();
    }

    render() {
        let { loading, user } = this.props.data;

        if (loading) {
            return (
                <div className="ui active loader"></div>
            );
        }

        let unexpectedQueries = _.chain(user.applications)
                                 .map("unexpectedQueries")
                                 .flatten()
                                 .sortBy("queriedAt")
                                 .reverse()
                                 .value();

        return (
            <div className="ij-dashboard ui mobile stackable grid">
                <div className="sixteen wide column">
                    <h1 className="ui header">
                        Dashboard
                    </h1>
                </div>
                <div className="section" style={{marginTop: 0}}>
                    <h3 className="ui sub header">Credits:</h3>
                    <p className="instructions">
                        <span>Your account current has <strong>{commas(user.credits)}</strong> credits remaining. </span>
                        {
                            user.refill ? (
                                <span>Your account is configured to purchase an additional <strong>{commas(user.refillAmount)}</strong> credits once it reaches <strong>{commas(user.refillTrigger)}</strong> remaining credits. </span>
                            ) : (
                                <span>Your account is not configured to purchase additional credits. </span>
                            )
                        }
                        <span>Feel free to edit these settings, or manually purchase additional credits in <Link to="/account">your account settings</Link>.</span>
                    </p>
                    <div className="ui indicating progress" data-percent={(user.credits/user.refillAmount) * 100}>
                        <div className="bar"></div>
                    </div>
                </div>

                <div className="section" style={{width: "100%"}}>
                    <h3 className="ui sub header">Alerts:</h3>
                    {
                        _.isEmpty(unexpectedQueries) ? (
                            <div>
                                <p className="instructions">
                                    Your application hasn't made any unexpected queries. Congratulations!
                                </p>
                            </div>
                        ) : (
                            <div>
                                <p className="instructions">
                                    We've detected {unexpectedQueries.length} unexpected {unexpectedQueries.length == 1 ? "query" : "queries"} in your application{user.applications.length == 1 ? "" : "s"}. These may be the result of NoSQL Injection attacks.
                                </p>
                                <div className="ui cards">
                                    {
                                        unexpectedQueries.map(query => {
                                            return (
                                                <div key={query.id} className="ui fluid notification card">
                                                    <div className="content">
                                                        <div className="right floated meta">
                                                            <div className="ui icon buttons">
                                                                <Link to={`/application/${query.application.id}`} className="ui button" data-tooltip="See more details about this unexpected query." data-position="top right"><i className="arrow right icon"></i></Link>
                                                            </div>
                                                        </div>
                                                        <p className="">We've detected an <strong style={{color: "#ea5e5e", margin: 0}}>unexpected query</strong> in <strong>{query.application.name}</strong>. The last time it was seen was <Moment fromNow>{query.queriedAt}</Moment>.</p>
                                                    </div>
                                                </div>
                                            );
                                        })
                                    }
                                </div>
                            </div>
                        )
                    }
                </div>
            </div>
        );
    }
};

export default graphql(gql`
    query {
        user {
            id
            credits
            refill
            refillTrigger
            refillAmount
            applications {
                name
                unexpectedQueries {
                    id
                    queriedAt
                    application {
                        id
                        name
                    }
                }
                expectedQueries {
                    id
                    queriedAt
                    application {
                        id
                        name
                    }
                }
            }
        }
    }
`)(Dashboard);
