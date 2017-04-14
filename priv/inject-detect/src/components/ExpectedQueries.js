import React from "react";
import _ from "lodash";
import { PrismCode } from "react-prism";

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
                <table className="ui selectable olive table">
                    <thead>
                        <tr>
                            <th>Query Type</th>
                            <th>Collection</th>
                            <th>Query</th>
                        </tr>
                    </thead>
                    <tbody>
                        {application.expectedQueries.map(query => {
                             return (
                                 <tr>
                                     <td>{query.type}</td>
                                     <td>{query.collection}</td>
                                     <td>
                                         <PrismCode className="language-javascript">
                                             {query.query}
                                             {/* {"{foo: \"bar\", baz: \"asdf\", bar: {hello: \"how are you?\", fine: 12345}, another: {hello: \"how are you?\", fine: 12345}}"} */}
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

export default ExpectedQueries;
