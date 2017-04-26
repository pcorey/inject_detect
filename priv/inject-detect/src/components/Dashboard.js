import React from "react";
import _ from "lodash";
import { Link } from "react-router-dom";
import { UserQuery } from "../graphql";
import { graphql } from "react-apollo";

class Dashboard extends React.Component {

    render() {
        let { loading, user } = this.props.data;

        if (loading) {
            return (
                <div className="ui active loader"></div>
            );
        }

        return (

            <div className="ij-dashboard ui mobile reversed stackable grid">

                <div className="sixteen wide column">
                    <h1 className="ui header">
                        Dashboard
                    </h1>
                </div>

                <div className="section" style={{marginTop: 0}}>
                    <h3 className="ui sub header">Credits:</h3>
                    <p className="instructions">
                        Your account current has <strong>2,532</strong> credits remaining. Your account is configured to purchase an additional <strong>100,000</strong> credits once it reaches <strong>2,000</strong> remaining credits. Feel free to edit these settings, or manually purchase additional credits in <Link to="/">your profile</Link>.
                    </p>
                    <div className="ui progress">
                        <div className="bar"></div>
                    </div>
                </div>

                <div className="section">
                    <h3 className="ui sub header">Applications:</h3>
                    <p className="instructions">
                        We've detected unexpected queries in 1 of your applications. We recommend you investigate these queries immediately.
                    </p>
                    <div className="ui cards">
                        <div className="ui fluid card">
                            <div className="content">
                                <div className="right floated meta">
                                    <div className="ui icon buttons">
                                        <button className="ui button" data-tooltip="See more details about this unexpected query." data-position="top right"><i className="expand icon"></i></button>
                                    </div>
                                </div>
                                <div className="header">
                                    Test App
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        );
    }
};

export default graphql(UserQuery)(Dashboard);
