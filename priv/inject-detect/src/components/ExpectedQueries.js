import React from "react";
import _ from "lodash";
import Moment from 'react-moment';
import { PrismCode } from "react-prism";

class ExpectedQueries extends React.Component {

    render() {
        let { application } = this.props;

        function pretty(query) {
            return query
                .replace(/:"string"/g, ":String")
                .replace(/:"date"/g, ":Date");
        }

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
                                         <PrismCode className="language-javascript">{`db.${query.collection}.${query.type}(${pretty(query.query)})`}</PrismCode>
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
