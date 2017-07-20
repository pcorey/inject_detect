import Moment from 'react-moment';
import React from 'react';
import _ from 'lodash';
import { Link } from 'react-router-dom';
import { PrismCode } from 'react-prism';
import { line } from './pretty';

class UnexpectedQueries extends React.Component {
    render() {
        let { application } = this.props;

        if (_.isEmpty(application.unexpectedQueries)) {
            return (
                <div className="ui success message">
                    This application hasn't made any unexpected queries!
                </div>
            );
        } else {
            return (
                <div className="ui cards">
                    {_.chain(application.unexpectedQueries)
                        .sortBy('queriedAt')
                        .reverse()
                        .map(query => {
                            return (
                                <div className="ui fluid unexpected-query-card card" key={query.id}>
                                    <div className="content">
                                        <div className="right floated meta">
                                            Last seen: <Moment fromNow>{query.queriedAt}</Moment>
                                            <div className="ui icon buttons">
                                                <Link to={`/unexpected-query/${query.id}`} className="ui brand button">
                                                    {/* data-tooltip="See more details about this unexpected query."
                                                        data-position="top right" */}
                                                    <i className="right arrow icon" />
                                                </Link>
                                            </div>
                                        </div>
                                        <div className="header">
                                            <PrismCode className="language-javascript">{`db.${query.collection}.${query.type}(${line(query.query)})`}</PrismCode>
                                        </div>
                                    </div>
                                </div>
                            );
                        })
                        .value()}
                </div>
            );
        }

        return (
            <div className="application-secret">
                <code>{application.token}</code>
                <button className="mini ui button">
                    <i className="ui refresh icon" />
                    Create New Secret
                </button>
            </div>
        );
    }
}

export default UnexpectedQueries;
