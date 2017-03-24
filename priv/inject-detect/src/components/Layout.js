import React from 'react';

import "./Layout.css";
import Header from "./Header";

function Layout(props) {
    return (
        <div className="ij-layout">
            <Header/>
            <div id="maincontent" className="ui main container">
                {props.children}
            </div>
        </div>
    );
}

export default Layout;
