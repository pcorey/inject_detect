import Moment from 'react-moment';
import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { ApplicationQuery } from "../graphql";
import { PrismCode } from "react-prism";
import { Redirect, Link } from "react-router-dom";
import { block, line } from "./pretty";
import { graphql } from "react-apollo";

class UnexpectedQuery extends React.Component {

    state = {
        markingAsExpected: false,
        markingAsHandled: false,
        redirect: false
    }

    markAsExpected = () => {
        let unexpectedQuery = this.props.data.unexpectedQuery;
        this.setState({ markingAsExpected: true });
        this.props.markAsExpected(unexpectedQuery.application.id, unexpectedQuery.id)
            .catch((err) => {
                console.error(err);
            })
            .then(() => {
                this.setState({ markingAsExpected: false, redirect: true });
            });
    }

    markAsHandled = () => {
        let unexpectedQuery = this.props.data.unexpectedQuery;
        this.setState({ markingAsHandled: true });
        this.props.markAsHandled(unexpectedQuery.application.id, unexpectedQuery.id)
            .catch((err) => {
                console.error(err);
            })
            .then(() => {
                this.setState({ markingAsHandled: false, redirect: true });
            });
    }

    render() {
        let { unexpectedQuery, loading } = this.props.data;
        let { markingAsExpected, markingAsHandled, redirect } = this.state;

        if (redirect) {
            return (
                <Redirect to={`/application/${unexpectedQuery.application.id}`}/>
            );
        }

        if (loading) {
            return (
                <div className="ui active loader"></div>
            );
        }
        else if (unexpectedQuery) {
            return (
                <div className="ij-unexpected-query ui mobile stackable grid">

                    <div className="sixteen wide column">
                        <h1 className="ui header">
                            Unexpected Query: {unexpectedQuery.application.name}
                        </h1>
                    </div>

                                <div className="six wide column">
                                    <h3 className="ui sub header">Query Structure:</h3>
                                    <PrismCode className="structure language-javascript">{`db.${unexpectedQuery.collection}.${unexpectedQuery.type}(${block(unexpectedQuery.query)})`}</PrismCode>
                                    {
                                        !unexpectedQuery.handled ? (
                                            <button disabled={unexpectedQuery.expected || unexpectedQuery.handled} className={`ui labeled icon button ${markingAsExpected ? "loading" : ""}` }onClick={this.markAsExpected}>
                                                <i className="checkmark icon"/>
                                                Mark{unexpectedQuery.expected ? "ed" : ""} as expected
                                            </button>
                                        ) : (null)
                                    }
                                    {
                                        !unexpectedQuery.expected ? (
                                            <button disabled={unexpectedQuery.expected || unexpectedQuery.handled} className={`ui brand labeled icon button ${markingAsHandled ? "loading" : ""}` }onClick={this.markAsHandled}>
                                                <i className="remove icon"/>
                                                Mark{unexpectedQuery.handled ? "ed" : ""} as handled
                                            </button>
                                        ) : (null)
                                    }
                                    <h3 className="ui sub header">Help / FAQ:</h3>
                                    <div className="ui bulleted list">
                                        <a className="item">What does this mean?</a>
                                        <a className="item">What was the exact query?</a>
                                        <a className="item">Was I attacked?</a>
                                        <a className="item">What now?</a>
                                    </div>
                                </div>
                                <div className="ten wide column">
                                    <h3 className="ui sub header">Information:</h3>
                                    <p className="instructions">
                                        This query has been detected <strong>{unexpectedQuery.seen}</strong> times in the "{unexpectedQuery.application.name}" application. It was last seen <strong><Moment fromNow>{unexpectedQuery.queriedAt}</Moment></strong>.
                                    </p>
                                    <p className="instructions">If this doesn't look like a type of query your application would make, it may be the result of a <a href="#">NoSQL Injection attack</a>. Try to find locations in your application making similar queries and look for potential injection vulnerabilities.</p>
                                    {
                                        JSON.parse(unexpectedQuery.similarQuery) ? (
                                            <div>
                                                <p className="instructions">Here's the most <Link to="#">similar expected query</Link> we found when we spotted this query:</p>
                                                <PrismCode className="language-javascript">{`db.${unexpectedQuery.collection}.${unexpectedQuery.type}(${line(unexpectedQuery.similarQuery)})`}</PrismCode>
                                            </div>
                                        ) : (
                                            <p className="instructions">We couldn't find any <Link to="#">similar expected queries</Link> when we spotted this query.</p>
                                        )
                                    }
                                    <p className="instructions">Once you've identified where this unexpected query came from and fixed the vulnerability, mark this query as <strong>handled</strong>.</p>
                                    <p className="instructions">Otherwise, if this is a query that your application is expected to make, mark it as <strong>expected</strong>.</p>
                                </div>

                </div>
            );
        }
        else {
            return (
                <div>Query not found...</div>
            );
        }
    }
};

const MarkAsExpected = graphql(gql`
    mutation markQueryAsExpected ($application_id: String!, $query_id: String!) {
        markQueryAsExpected(application_id: $application_id, query_id: $query_id) {
            id
            unexpectedQueries {
                id
                collection
                queriedAt
                query
                type
            }
        }
    }
`, {
    props: ({ mutate }) => ({
        markAsExpected: (application_id, query_id) => mutate({
            variables: { application_id, query_id },
            refetchQueries: [{
                query: ApplicationQuery,
                variables: { id: application_id }
            }]
        })
    })
});

const MarkAsHandled = graphql(gql`
    mutation markQueryAsHandled ($application_id: String!, $query_id: String!) {
        markQueryAsHandled(application_id: $application_id, query_id: $query_id) {
            id
            unexpectedQueries {
                id
                collection
                queriedAt
                query
                type
            }
        }
    }
`, {
    props: ({ mutate }) => ({
        markAsHandled: (application_id, query_id) => mutate({
            variables: { application_id, query_id },
            refetchQueries: [{
                query: ApplicationQuery,
                variables: { id: application_id }
            }]
        })
    })
});

const Query = graphql(gql`
    query unexpectedQuery($id: String!) {
        unexpectedQuery(id: $id) {
            id
            query
            queriedAt
            collection
            seen
            similarQuery
            type
            expected
            handled
            application {
                id
                name
            }
        }
    }
`, {
    options: props => ({
        variables: {
            id: _.get(props, "match.params.id")
        },
        pollInterval: 5000
    })
});

export default MarkAsExpected(MarkAsHandled(Query(UnexpectedQuery)));
