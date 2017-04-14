import React from "react";
import _ from "lodash";
import Moment from 'react-moment';
import { PrismCode } from "react-prism";

class UnexpectedQueries extends React.Component {

    render() {
        let { application } = this.props;

        if (_.isEmpty(application.unexpectedQueries)) {
            return (
                <div className="ui success message">
                    This application hasn't made any unexpected queries!
                </div>
            );
        }
        else {
            return (
                <table className="ui selectable red table">
                    <thead>
                        <tr>
                            <th>Last seen</th>
                            <th>Query type</th>
                            <th>Collection</th>
                            <th>Query</th>
                        </tr>
                    </thead>
                    <tbody>
                        {application.unexpectedQueries.map(query => {
                             return (
                                 <tr>
                                     <td><Moment fromNow>{query.queriedAt}</Moment></td>
                                     <td>{query.type}</td>
                                     <td>{query.collection}</td>
                                     <td>
                                         <PrismCode className="language-javascript">
                                             {query.query}
                                         </PrismCode>
                                     </td>
                                 </tr>
                             );
                         })}
                    </tbody>
                </table>
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
