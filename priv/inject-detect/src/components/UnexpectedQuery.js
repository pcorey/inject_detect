import Moment from 'react-moment';
import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { Link } from "react-router-dom";
import { PrismCode } from "react-prism";
import { block, line } from "./pretty";
import { graphql } from "react-apollo";

class UnexpectedQuery extends React.Component {

    render() {
        let { unexpectedQuery, loading } = this.props.data;

        function similar(query) {
            return query;
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
                                            <button disabled={unexpectedQuery.expected || unexpectedQuery.handled} className="ui labeled icon button">
                                                <i className="checkmark icon"/>
                                                Mark{unexpectedQuery.expected ? "ed" : ""} as expected
                                            </button>
                                        ) : (null)
                                    }
                                    {
                                        !unexpectedQuery.expected ? (
                                            <button disabled={unexpectedQuery.expected || unexpectedQuery.handled} className="ui brand labeled icon button">
                                                <i className="remove icon"/>
                                                Mark{unexpectedQuery.handled ? "ed" : ""} as handled
                                            </button>
                                        ) : (null)
                                    }
                                    <h3 className="ui sub header">Help:</h3>
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
                                                <p className="instructions">Here's the most similar expected query we had on record at the time we spotted this query:</p>
                                                <PrismCode className="language-javascript">{`db.${unexpectedQuery.collection}.${unexpectedQuery.type}(${line(unexpectedQuery.similarQuery)})`}</PrismCode>
                                            </div>
                                        ) : (
                                            <p className="instructions">We didn't have any similar expected queries on record when we spotted this query.</p>
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

export default graphql(gql`
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
})(UnexpectedQuery);
