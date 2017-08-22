import ExpectedQueries from './ExpectedQueries';
import ApplicationSettings from './ApplicationSettings';
import React from 'react';
import UnexpectedQueries from './UnexpectedQueries';
import _ from 'lodash';
import gql from 'graphql-tag';
import { ApplicationQuery } from '../graphql';
import { Link } from 'react-router-dom';
import { graphql } from 'react-apollo';

class Application extends React.Component {
    render() {
        let { application, loading } = this.props.data;

        if (!application) {
            return null;
        }

        if (loading) {
            return <div className="ui active loader" />;
        } else if (application) {
            return (
                <div className="ij-application ui mobile reversed stackable grid">

                    <div className="sixteen wide column">
                        <h1 className="ui header">
                            Application: {application.name}
                        </h1>

                        <div className="ui icon message application-configuration" style={{ marginTop: '4em' }}>
                            <i className="settings icon" />
                            <div className="content configuration">
                                <div>
                                    <div className="header">Application configuration</div>
                                    <p>
                                        Training mode is
                                        {' '}
                                        <strong>{application.trainingMode ? 'on' : 'off'}</strong>
                                        . Alerting is
                                        {' '}
                                        <strong>{application.alerting ? 'on' : 'off'}</strong>
                                        .
                                    </p>
                                </div>
                                <ApplicationSettings application={application} />
                            </div>
                        </div>

                        <div className="section">
                            <h3 className="ui sub header">Unxpected queries:</h3>
                            {application.unexpectedQueries.length
                                ? <div>
                                      <div className="ui grid">
                                          <div className="thirteen wide column">
                                              <p className="instructions">
                                                  We've detected
                                                  {' '}
                                                  {application.unexpectedQueries.length}
                                                  {' '}
                                                  unexpected queries made against your application. If any of the queries below seem suspicious, they may be the result of a NoSQL Injection attack. Use
                                                  {' '}
                                                  <a href="http://www.injectdetect.com/education/">
                                                      our guides and suggestions
                                                  </a>
                                                  {' '}
                                                  to track down and fix any queries in your application that may be vulnerable to NoSQL Injection attacks.
                                              </p>
                                          </div>
                                          <div className="three wide column graphic container">
                                              <i className="ui warning sign graphic icon" />
                                          </div>
                                      </div>
                                      <UnexpectedQueries application={application} />
                                  </div>
                                : <div>
                                      <div className="ui grid">
                                          <div className="thirteen wide column">
                                              <p className="instructions">
                                                  <span>
                                                      We haven't detected any unexpected queries made against your application. Congratulations!
                                                      {' '}
                                                  </span>
                                                  {application.trainingMode
                                                      ? <span />
                                                      : <span>We'll keep an eye out for any unexpected queries.</span>}
                                              </p>
                                          </div>
                                          <div className="three wide column graphic container">
                                              <i className="ui green checkmark graphic icon" />
                                          </div>
                                      </div>
                                  </div>}
                        </div>

                        <div className="section">
                            <h3 className="ui sub header">Expected queries:</h3>
                            {application.expectedQueries.length
                                ? <div>
                                      <div className="ui grid">
                                          <div className="thirteen wide column">
                                              <p className="instructions">
                                                  Your application is expecting
                                                  {' '}
                                                  {application.expectedQueries.length}
                                                  {' '}
                                                  {application.expectedQueries.length == 1
                                                      ? 'type of query'
                                                      : 'different queries'}
                                                  . Add more queries by setting your application into
                                                  {' '}
                                                  <strong>Training Mode</strong>
                                                  , or marking unexpected queries as expected.
                                              </p>
                                          </div>
                                      </div>
                                      <ExpectedQueries application={application} />
                                  </div>
                                : <div className="ui grid">
                                      <div className="thirteen wide column">
                                          {application.trainingMode
                                              ? <p className="instructions">
                                                    Your application doesn't have any expected queries. Your application is in
                                                    {' '}
                                                    <strong>Training Mode</strong>
                                                    {' '}
                                                    so any detected queries will automatically become expected queries for this application.
                                                </p>
                                              : <p className="instructions">
                                                    Your application doesn't have any expected queries. Add more expected queries by turning on
                                                    {' '}
                                                    <strong>Training Mode</strong>
                                                    {' '}
                                                    and generating queries within your application, or by marking unexpected queries as expected.
                                                </p>}
                                      </div>
                                  </div>}
                        </div>

                    </div>

                </div>
            );
        } else {
            return <div>Application not found...</div>;
        }
    }
}

const Query = graphql(ApplicationQuery, {
    options: props => ({
        variables: {
            id: _.get(props, 'match.params.id')
        },
        reducer: (previousResults, action) => {
            switch (action.operationName) {
                case 'getStarted':
                    return _.extend({}, previousResults, {
                        user: _.get(action, 'result.data.getStarted')
                    });
                case 'signOut':
                    return _.extend({}, previousResults, {
                        user: null
                    });
                default:
                    return previousResults;
            }
        },
        pollInterval: 5000
    })
});

const RemoveExpectedQuery = graphql(
    gql`
    mutation removeExpectedQuery ($application_id: String!, $query_id: String!) {
        removeExpectedQuery(application_id: $application_id, query_id: $query_id) {
            id
            expectedQueries {
                id
            }
        }
    }
`,
    {
        props: ({ mutate }) => ({
            removeExpectedQuery: (application_id, query_id) =>
                mutate({
                    variables: { application_id, query_id },
                    refetchQueries: [
                        {
                            query: ApplicationQuery,
                            variables: { id: application_id }
                        }
                    ]
                })
        })
    }
);

export default RemoveExpectedQuery(Query(Application));
