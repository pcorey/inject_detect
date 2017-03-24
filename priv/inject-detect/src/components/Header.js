import React from 'react';

import "./Header.css";

function Header() {
    return (
        <div className="ui fixed menu">
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

export default Header;
