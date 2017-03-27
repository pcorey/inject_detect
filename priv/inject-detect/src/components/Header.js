import React from 'react';
import gql from 'graphql-tag';
import { Link } from 'react-router-dom';
import { graphql } from 'react-apollo';

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
        let { loading, currentUser } = this.props.data;
        if (currentUser) {
            return (
                <div className="ui fixed menu ij-header">
                    <div className="ui container">
                        <Link to="/" className="header borderless item">
                            <img alt="Inject Detect Logo" src="https://s3.amazonaws.com/www.injectdetect.com/logo.png" className="icon"/>
                            Inject Detect
                        </Link>

                        <a href="#" className="active borderless item">Dashboard</a>

                        <div className="ui simple dropdown borderless item">
                            Applications <i className="dropdown icon"></i>
                            <div className="menu">
                                <a className="item" href="#">Foo Application</a>
                                <a className="item" href="#">Bar Application</a>
                            </div>
                        </div>

                        <div className="right menu">
                            <div className="borderless item">
                                <button id="userbutton" className="ui right labeled icon brand dropdown button">
                                    <i className="caret down icon"></i>
                                    {currentUser.email}
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
    query {
        currentUser {
            id
            email
        }
    }
`)(Header);
