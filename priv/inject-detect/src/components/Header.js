import React from "react";
import gql from "graphql-tag";
import { Link, NavLink } from "react-router-dom";
import { graphql } from "react-apollo";
import _ from "lodash";

import SignOutLink from "./SignOutLink";

class Header extends React.Component {

    initDropdown() {
        window.$('.ui.dropdown').dropdown();
    }

    componentDidMount() {
        this.initDropdown();
    }

    componentDidUpdate() {
        this.initDropdown();
    }

    render() {
        let { user } = this.props.data;

        if (user) {
            return (
                <div className="ui fixed menu ij-header">
                    <div className="ui container">
                        <Link to="/" className="header borderless item">
                            <img alt="Inject Detect Logo" src="https://s3.amazonaws.com/www.injectdetect.com/logo.png" className="icon"/>
                            Inject Detect
                        </Link>

                        <NavLink to="/dashboard" className="borderless item">Dashboard</NavLink>

                        <div className="ui simple dropdown borderless item">
                            Applications <i className="dropdown icon"></i>
                            <div className="menu">

                                { user &&
                                  user.applications &&
                                  user.applications.map((application) => {
                                      return (
                                          <Link to={`/application/${application.id}`} key={application.id} className="item"><i className="red warning icon"/>{application.applicationName}</Link>
                                      );
                                  })}

                                <Link to={`/dashboard/add`} className="item"><i className="plus icon"/>Add Application</Link>
                            </div>
                        </div>

                        <div className="right menu">
                            <div className="borderless item">
                                <button id="userbutton" className="ui right labeled icon brand dropdown button">
                                    <i className="caret down icon"></i>
                                    {user.email}
                                    <div className="menu">
                                        <SignOutLink>Sign out</SignOutLink>
                                    </div>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            );
        }
        else {
            return (
                <div className="ui fixed menu ij-header">
                    <div className="ui container">
                        <Link to="/" className="header borderless item">
                            <img alt="Inject Detect Logo" src="https://s3.amazonaws.com/www.injectdetect.com/logo.png" className="icon"/>
                            Inject Detect
                        </Link>

                        <div className="right menu">
                            <div className="borderless item">
                                <Link to="/sign-in" className="ui right brand button">
                                    Sign in
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            );
        }
    }
}

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
`, {
    options({ params }) {
        return {
            reducer: (previousResults, action) => {
                switch (action.operationName) {
                    case "verifyRequestedToken":
                        return { user: _.get(action, "result.data.verifyRequestedToken") };
                    case "getStarted":
                        return { user: _.get(action, "result.data.getStarted") };
                    case "signOut":
                        return { user: null };
                    default:
                        return previousResults;
                }
            }
        };
    }
})(Header);
