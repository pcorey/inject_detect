import React from "react";
import ReactDOM from "react-dom";
import _ from "lodash";
import { ApolloProvider } from "react-apollo";
import { BrowserRouter, Route } from "react-router-dom";

import { client } from "./apollo";

import "./styles/index.styl";
import Application from "./components/Application";
import Dashboard from "./components/Dashboard";
import GetStarted from "./components/GetStarted";
import Header from "./components/Header";
import PrivateRoute from "./components/PrivateRoute";
import SignIn from "./components/SignIn";
import VerifyRequestedToken from "./components/VerifyRequestedToken";

ReactDOM.render(
    (
        <ApolloProvider client={client}>
            <BrowserRouter>
                <div className="ij-layout">
                    <Header/>
                    <div className="ij-layout-content ui main container">
                        <Route exact path="/" component={GetStarted}/>
                        <Route path="/sign-in" component={SignIn}/>
                        <Route path="/verify/:token" component={VerifyRequestedToken}/>
                        <PrivateRoute exact path="/dashboard" component={Dashboard}/>
                        <PrivateRoute path="/application/:id" component={Application}/>
                    </div>
                </div>
            </BrowserRouter>
        </ApolloProvider>
    ),
    document.getElementById('root')
);
