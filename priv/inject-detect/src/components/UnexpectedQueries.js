import React from "react";
import _ from "lodash";

class UnexpectedQueries extends React.Component {

    render() {
        let { application } = this.props;

        if (_.isEmpty(application.unexpectedQueries)) {
            return (
                <div className="ui success message">
                    {application.name} hasn't made any unexpected queries!
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
                                     <td>{query.queriedAt}</td>
                                     <td>{query.type}</td>
                                     <td>{query.collection}</td>
                                     <td>{query.query}</td>
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
