import React from 'react';
import ReactDOM from 'react-dom';
import _ from "lodash";
import { ApolloProvider } from 'react-apollo';
import { BrowserRouter, Route } from 'react-router-dom';

import { client } from "./apollo";

import "./styles/index.styl";
import Header from "./components/Header";
import SignIn from "./components/SignIn";
import GetStarted from "./components/GetStarted";

ReactDOM.render(
    (
        <ApolloProvider client={client}>
            <BrowserRouter>
                <div className="ij-layout">
                    <Header/>
                    <div className="ij-layout-content ui main container">
                        <Route exact path="/" component={GetStarted}/>
                        <Route path="/sign-in" component={SignIn}/>
                        <Route path="/sign-in/:token" component={SignIn}/>
                    </div>
                </div>
            </BrowserRouter>
        </ApolloProvider>
    ),
    document.getElementById('root')
);
