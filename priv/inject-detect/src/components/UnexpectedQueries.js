import React from "react";
import _ from "lodash";
import Moment from 'react-moment';
import { PrismCode } from "react-prism";

class UnexpectedQueries extends React.Component {

    render() {
        let { application } = this.props;

        function pretty(query) {
            return query
                .replace(/:"string"/g, ":String")
                .replace(/:"date"/g, ":Date");
        }

        if (_.isEmpty(application.unexpectedQueries)) {
            return (
                <div className="ui success message">
                    This application hasn't made any unexpected queries!
                </div>
            );
        }
        else {
            return (
                <div className="ui cards">
                {
                    application.unexpectedQueries.map(query => {
                        return (
                            <div className="ui fluid card">
                                <div className="content">
                                    <div className="right floated meta">
                                        Last seen: <Moment fromNow>{query.queriedAt}</Moment>
                                        {/* <button className="ui icon button">
                                            <i className="trash icon"></i>
                                            </button> */}
                                    </div>
                                    <div className="header">
                                        <PrismCode className="language-javascript">{`db.${query.collection}.${query.type}(${pretty(query.query)})`}</PrismCode>
                                    </div>
                                </div>
                            </div>
                        );
                    })
                }
                </div>
            )
        }

        return (
            <div className="application-secret">
                <code>{application.token}</code>
                <button className="mini ui button">
                    <i className="ui refresh icon"/>
                    Create New Secret
                </button>
            </div>
        );
    }
};

export default UnexpectedQueries;
