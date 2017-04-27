import Moment from 'react-moment';
import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { Link } from "react-router-dom";
import { PrismCode } from "react-prism";
import { graphql } from "react-apollo";

class UnexpectedQuery extends React.Component {

    render() {
        let { unexpectedQuery, loading } = this.props.data;

        function pretty(query) {
            return JSON.stringify(JSON.parse(query), null, 4)
                .replace(/: "string"/g, ": String")
                .replace(/: "date"/g, ": Date");
        }

        if (loading) {
            return (
                <div className="ui active loader"></div>
            );
        }
        else if (unexpectedQuery) {
            return (
                <div className="ij-unexpected-query ui mobile reversed stackable grid">

                    <div className="sixteen wide column">
                        <h1 className="ui header">
                            Unexpected Query: {unexpectedQuery.application.name}
                        </h1>
                    </div>

                    <div className="sixteen wide column">
                        <div className="section">
                            <div className="ui grid">
                                <div className="six wide column">
                                    <h3 className="ui sub header">Query Structure:</h3>
                                    <PrismCode className="structure language-javascript">{`db.${unexpectedQuery.collection}.${unexpectedQuery.type}(${pretty(unexpectedQuery.query)})`}</PrismCode>
                                    <button className="ui green labeled icon button">
                                        <i className="checkmark icon"/>
                                        Mark as expected
                                    </button>
                                    <button className="ui brand labeled icon button">
                                        <i className="remove icon"/>
                                        Mark as handled
                                    </button>
                                    <p className="instructions"><a href="#">What was the exact query?</a></p>
                                    <p className="instructions"><a href="#">Is it NoSQL Injection?</a></p>
                                </div>
                                <div className="ten wide column">
                                    <h3 className="ui sub header">Information:</h3>
                                    <p className="instructions">
                                        This query has been detected <strong>{unexpectedQuery.seen}</strong> times in the "{unexpectedQuery.application.name}" application. It was last seen <strong><Moment fromNow>{unexpectedQuery.queriedAt}</Moment></strong>.
                                    </p>
                                    <p className="instructions">If this doesn't look like a query your application would make, it may be the result of a <a href="#">NoSQL Injection attack</a>. Try to find locations in your application making similar queries and look for potential injection vulnerabilities.</p>
                                    <p className="instructions">Here's the most similar expected query we have on record for your application:</p>
                                    <PrismCode className="language-javascript">{`db.${unexpectedQuery.collection}.${unexpectedQuery.type}(${unexpectedQuery.query})`}</PrismCode>
                                    <p className="instructions">Once you've identified where this unexpected query came from and fixed the vulnerability, mark this query as <strong>handled</strong>.</p>
                                    <p className="instructions">Otherwise, if this is a query that your application is expected to make, mark it as <strong>expected</strong>.</p>
                                </div>
                            </div>
                        </div>
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
            type
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
