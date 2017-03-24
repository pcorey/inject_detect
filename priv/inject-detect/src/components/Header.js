import React from 'react';
import gql from 'graphql-tag';
import { graphql } from 'react-apollo';

import "./Header.css";

function Header({ data: { loading, currentUser } }) {
    if (currentUser) {
        return (
            <div className="ui fixed menu ij-header">
                <div className="ui container">
                    <a href="#" className="header borderless item">
                        <img src="https://s3.amazonaws.com/www.injectdetect.com/logo.png" className="icon"/>
                        Inject Detect
                    </a>

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
                            <button id="userbutton" className="ui right labeled icon red button">
                                <i className="caret down icon"></i>
                                petefoo@email.com
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
                    <a href="#" className="header borderless item">
                        <img src="https://s3.amazonaws.com/www.injectdetect.com/logo.png" className="icon"/>
                        Inject Detect
                    </a>

                    <div className="right menu">
                        <div className="borderless item">
                            <a href="#">Sign in</a>
                        </div>
                    </div>
                </div>
            </div>
        );
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
