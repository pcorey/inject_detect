import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { graphql } from "react-apollo";

/* import ApplicationSecret from "./ApplicationSecret";*/

class Application extends React.Component {

    render() {
        let { user } = this.props.data;
        let id = _.get(this.props, "match.params.id");
        let application = _.find(user && user.applications, app => app.id == id);

        return (

            <div className="ij-dashboard ui mobile reversed stackable grid">

                <div className="sixteen wide column">
                    <h1 style={{fontSize: "3em", fontWeight: 100}}>{application && application.applicationName}</h1>
                    {/* { application && <ApplicationSecret application={application}/> } */}
                    <h3>
                        Unexpected queries:
                    </h3>
                    <div className="ui success message">Your application hasn't made any unexpected queries!</div>
                    <h3>
                        Expected queries:
                    </h3>
                    <div className="ui middle aligned selection divided list">
                        <div className="item">
                            <img className="ui avatar image" src="https://semantic-ui.com/images/avatar/small/helen.jpg"/>
                            <div className="content">
                                <div className="header">Helen</div>
                            </div>
                            <i className="right floated green plus icon"/>
                        </div>
                        <div className="item">
                            <img className="ui avatar image" src="https://semantic-ui.com/images/avatar/small/christian.jpg"/>
                            <div className="content">
                                <div className="header">Christian</div>
                            </div>
                        </div>
                        <div className="item">
                            <img className="ui avatar image" src="https://semantic-ui.com/images/avatar/small/daniel.jpg"/>
                            <div className="content">
                                <div className="header">Daniel</div>
                            </div>
                        </div>
                    </div>
                    <h3>
                        Handled unexpected queries:
                    </h3>
                </div>

            </div>
        );
    }
};

export default graphql(gql`
    query user {
        user {
            id
            email
            applications {
                id
                applicationName
            }
        }
    }
`)(Application);
