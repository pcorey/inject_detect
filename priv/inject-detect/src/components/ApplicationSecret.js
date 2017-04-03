import React from "react";
import _ from "lodash";
/* import gql from "graphql-tag";
 * import { graphql } from "react-apollo";*/

class ApplicationSecret extends React.Component {

    render() {
        let { application } = this.props;

        return (
            <div className="application-secret">
                <code>{application.id}</code>
                <button className="mini ui button">
                    <i className="ui refresh icon"/>
                    Create New Secret
                </button>
            </div>
        );
    }
};

export default ApplicationSecret;
