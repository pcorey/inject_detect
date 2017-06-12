import Moment from 'react-moment';
import React from 'react';
import _ from 'lodash';
import gql from 'graphql-tag';
import { Link } from 'react-router-dom';
import { commas } from './pretty';
import { graphql } from 'react-apollo';

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
            return <div className="ui active loader" />;
        }

        let expectedQueries = _.get(user, 'applications.expectedQueries');

        let unexpectedQueries = _.chain(user.applications)
            .map('unexpectedQueries')
            .flatten()
            .sortBy('queriedAt')
            .reverse()
            .value();

        if (_.isEmpty(expectedQueries) && _.isEmpty(unexpectedQueries)) {
            return (
                <div className="ij-dashboard ui mobile stackable grid">
                    <div className="sixteen wide column">
                        <h1 className="ui header">
                            Welcome to Inject Detect!
                        </h1>
                    </div>
                    <div className="section" style={{ marginTop: 0 }}>
                        {/* <h3 className="ui sub header">Credits:</h3> */}
                        <p className="instructions">
                            We've gone ahead and set up your
                            {' '}
                            <Link to={`/application/${user.applications[0].id}`}>first application</Link>
                            . Check out our
                            {' '}
                            <a href="#">Getting Started</a>
                            {' '}
                            guide to get your Meteor application up and running with your new Inject Detect account.
                            {' '}
                        </p>
                        <hr
                            style={{ border: 0, 'border-bottom': '1px solid #ddd', width: '75%', margin: '2em auto' }}
                        />
                        <p className="instructions">
                            Your application is currently in
                            {' '}
                            <strong>training mode</strong>
                            . Every query made by your application will automatically be marked as an expected query. While in training mode, run your application through all of it's normal user stories to generate your application's complete set of expected queries. Once you're satisfied that you've captured every query made by your application,
                            {' '}
                            <strong>turn off training mode</strong>
                            .
                        </p>
                        <p className="instructions">
                            Once out of training mode, we'll compare every query made by your application against your set of expected queries. If we detect an
                            {' '}
                            <strong>unexpected query</strong>
                            , we'll send you en email alert, letting you know immediately.
                        </p>
                        <hr
                            style={{ border: 0, 'border-bottom': '1px solid #ddd', width: '75%', margin: '2em auto' }}
                        />
                        <p className="instructions">
                            Every query your application makes consumes an Inject Detect
                            {' '}
                            <strong>credit</strong>
                            . Your account is initially loaded with 10,000 credits, which means we'll handle up to 10,000 queries made by your application. Once your account runs out of credits, we'll stop monitoring incoming queries made by your application.
                        </p>
                        <p className="instructions">
                            You can
                            {' '}
                            <strong>buy more credits</strong>
                            {' '}
                            or configure
                            {' '}
                            <strong>automatic token purchases </strong>
                            in your
                            {' '}
                            <Link to="/account">account settings</Link>
                            .
                        </p>
                    </div>

                </div>
            );
        }

        return (
            <div className="ij-dashboard ui mobile stackable grid">
                <div className="sixteen wide column">
                    <h1 className="ui header">
                        Dashboard
                    </h1>
                </div>
                <div className="section" style={{ marginTop: 0 }}>
                    <h3 className="ui sub header">Credits:</h3>
                    <p className="instructions">
                        <span>
                            Your account current has <strong>{commas(user.credits)}</strong> credits remaining.{' '}
                        </span>
                        {user.refill
                            ? <span>
                                  Your account is configured to automatically purchase an additional
                                  {' '}
                                  <strong>{commas(user.refillAmount)}</strong>
                                  {' '}
                                  credits once it reaches
                                  {' '}
                                  <strong>{commas(user.refillTrigger)}</strong>
                                  {' '}
                                  remaining credits.
                                  {' '}
                              </span>
                            : <span>
                                  <strong>
                                      Your account is not configured to automatically purchase additional credits.{' '}
                                  </strong>
                              </span>}
                        <span>
                            You can edit these settings or manually purchase additional credits in
                            {' '}
                            <Link to="/account">your account settings</Link>
                            .
                        </span>
                    </p>
                    <div
                        className="ui indicating progress"
                        data-percent={Math.min(user.credits / user.refillAmount, 1) * 100}
                    >
                        <div className="bar" />
                    </div>
                </div>

                <div className="section" style={{ width: '100%' }}>
                    <h3 className="ui sub header">Alerts:</h3>
                    {_.isEmpty(unexpectedQueries)
                        ? <div>
                              <p className="instructions">
                                  Your application hasn't made any unexpected queries. Congratulations!
                              </p>
                          </div>
                        : <div>
                              <p className="instructions">
                                  We've detected
                                  {' '}
                                  {unexpectedQueries.length}
                                  {' '}
                                  unexpected
                                  {' '}
                                  {unexpectedQueries.length == 1 ? 'query' : 'queries'}
                                  {' '}
                                  in your application
                                  {user.applications.length == 1 ? '' : 's'}
                                  . These may be the result of NoSQL Injection attacks.
                              </p>
                              <div className="ui cards">
                                  {unexpectedQueries.map(query => {
                                      return (
                                          <div key={query.id} className="ui fluid notification card">
                                              <div className="content">
                                                  <div className="right floated meta">
                                                      <div className="ui icon buttons">
                                                          <Link
                                                              to={`/application/${query.application.id}`}
                                                              className="ui button"
                                                              title="See more details"
                                                          >
                                                              <i className="arrow right icon" />
                                                          </Link>
                                                      </div>
                                                  </div>
                                                  <p className="">
                                                      We've detected an
                                                      {' '}
                                                      <strong style={{ color: '#ea5e5e', margin: 0 }}>
                                                          unexpected query
                                                      </strong>
                                                      {' '}
                                                      in
                                                      {' '}
                                                      <strong>{query.application.name}</strong>
                                                      . The last time it was seen was
                                                      {' '}
                                                      <Moment fromNow>{query.queriedAt}</Moment>
                                                      .
                                                  </p>
                                              </div>
                                          </div>
                                      );
                                  })}
                              </div>
                          </div>}
                </div>
            </div>
        );
    }
}

export default graphql(
    gql`
    query {
        user {
            id
            credits
            refill
            refillTrigger
            refillAmount
            applications {
                id
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
`,
    {
        options: props => ({
            pollInterval: 5000
        })
    }
)(Dashboard);
