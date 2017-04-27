import Moment from 'react-moment';
import React from "react";
import _ from "lodash";
import { PrismCode } from "react-prism";
import { line } from "./pretty";

class ExpectedQueries extends React.Component {

    render() {
        let { application } = this.props;

        if (_.isEmpty(application.expectedQueries)) {
            return (
                <div className="ui warning message">
                    Your application doesn't have any expected queries.
                </div>
            );
        }
        else {
            return (
                <div className="ui cards">
                {
                    _.chain(application.expectedQueries)
                     .sortBy("queriedAt")
                     .reverse()
                     .map(query => {
                         return (
                             <div className="ui fluid card" key={query.id}>
                                 <div className="content">
                                     <div className="ui right floated meta">
                                         Last seen: <Moment fromNow>{query.queriedAt}</Moment>
                                         <button className="ui icon button" data-tooltip="Remove query from set of 'expected queries'." data-position="top right">
                                             <i className="trash icon"></i>
                                         </button>
                                     </div>
                                     <div className="header">
                                         <PrismCode className="language-javascript">{`db.${query.collection}.${query.type}(${line(query.query)})`}</PrismCode>
                                     </div>
                                 </div>
                             </div>
                         );
                     })
                     .value()
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

export default ExpectedQueries;
