import React from "react";
import { Redirect, Route } from "react-router-dom";

export default ({ component, ...rest }) => (
    <Route {...rest} render={props => (
            localStorage.getItem("authToken") ? (
                React.createElement(component, props)
            ) : ( <Redirect to={{
                pathname: '/sign-in',
                state: { from: props.location }
            }}/> )
        )}/>
)
