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

        if (_.isEmpty(_.chain(user.applications).map('queries').flatten().value())) {
            return (
                <div className="ij-dashboard ui mobile stackable grid">
                    <div className="sixteen wide column">
                        <h1 className="ui header">
                            Welcome to Inject Detect!
                        </h1>
                    </div>
                    <div className="section" style={{ marginTop: 0 }}>
                        <p className="instructions">
                            We've gone ahead and set up your new account and your
                            {' '}
                            <Link to={`/application/${user.applications[0].id}`}>first application</Link>
                            . Check out our
                            {' '}
                            <a href="http://www.injectdetect.com/terms/">Getting Started</a>
                            {' '}
                            guide for instructions on getting your Meteor application up and running with your new Inject Detect account.
                        </p>
                        <p className="instructions">
                            Your first application automatically starts out in
                            {' '}
                            <strong>training mode</strong>
                            , which means that every query it makes will automatically be marked as an
                            {' '}
                            <strong>expected query</strong>
                            . We suggest running your application through its courses, hitting all expected user stories before turning off training mode. Once out of training mode, we immediately notify you if the application makes any
                            {' '}
                            <strong>unexpected queries</strong>
                            {' '}
                            that may be the result of a NoSQL Injection attack.
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
                    <p className="instructions">
                        {_.get(user, 'active')
                            ? <span>
                                  Your account is
                                  {' '}
                                  <strong>active</strong>
                                  {' '}
                                  and we're currently monitoring all of your applications for NoSQL Injection attacks. Visit
                                  {' '}
                                  <Link to="/account">your account</Link>
                                  {' '}
                                  to update your payment information, or deactivate your account.
                              </span>
                            : <span>
                                  Your account is
                                  {' '}
                                  <strong>deactivated</strong>
                                  . We are not monitoring any of your applications for NoSQL Injection attacks. Visit
                                  {' '}
                                  <Link to="/account">your account</Link>
                                  {' '}
                                  to update your payment information and reactivate your account.
                              </span>}
                    </p>
                </div>

                <div className="section" style={{ width: '100%' }}>
                    <h3 className="ui sub header">Applications:</h3>
                    <div className="ui cards">
                        {_.sortBy(user.applications, 'name').map(application => {
                            let unexpectedQueries = _.filter(
                                application.queries,
                                query => !query.expected && !query.handled
                            );
                            if (_.isEmpty(unexpectedQueries)) {
                                return (
                                    <div key={application.id} className="ui fluid notification card">
                                        <div className="content">
                                            <div className="right floated meta">
                                                <div className="ui icon buttons">
                                                    <Link
                                                        to={`/application/${application.id}`}
                                                        className="ui button"
                                                        title="See more details"
                                                    >
                                                        <i className="arrow right icon" />
                                                    </Link>
                                                </div>
                                            </div>
                                            <p className="">
                                                <strong>{application.name}</strong>
                                                {' '}
                                                hasn't made any new unexpected queries. Nothing new to report.
                                            </p>
                                        </div>
                                    </div>
                                );
                            } else {
                                return (
                                    <div key={application.id} className="ui fluid notification card">
                                        <div className="content">
                                            <div className="right floated meta">
                                                <div className="ui icon buttons">
                                                    <Link
                                                        to={`/application/${application.id}`}
                                                        className="ui brand button"
                                                        title="See more details"
                                                    >
                                                        <i className="arrow right icon" />
                                                    </Link>
                                                </div>
                                            </div>
                                            <p className="">
                                                <strong>{application.name}</strong>
                                                {' '}
                                                has made
                                                {' '}
                                                <strong style={{ color: '#ea5e5e', margin: 0 }}>
                                                    {unexpectedQueries.length}
                                                    {' '}
                                                    unexpected
                                                    {' '}
                                                    {unexpectedQueries.length == 1 ? 'query' : 'queries'}
                                                    {' '}
                                                </strong>
                                                as recently as
                                                {' '}
                                                <Moment fromNow>
                                                    {_.sortBy(unexpectedQueries, 'queriedAt')[0].queriedAt}
                                                </Moment>
                                                .
                                            </p>
                                        </div>
                                    </div>
                                );
                            }
                        })}
                    </div>
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
                active
                applications {
                    id
                    name
                    queries {
                        id
                        queriedAt
                        expected
                        handled
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
