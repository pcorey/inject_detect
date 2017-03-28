import ApolloClient, { createNetworkInterface } from 'apollo-client';
import React from 'react';
import ReactDOM from 'react-dom';
import _ from "lodash";
import gql from 'graphql-tag';
import { ApolloProvider } from 'react-apollo';
import { BrowserRouter, Route } from 'react-router-dom';

import "./styles/index.styl";
import CurrentUser from "./CurrentUser";
import Header from "./components/Header";
import SignIn from "./components/SignIn";
import Users from "./Users";

const networkInterface = createNetworkInterface({
    uri: _.get(process.env, "REACT_APP_GRAPHQL_URL"),
    dataIdFromObject: object => console.log(object) && object.id
});

const client = new ApolloClient({
    networkInterface,
});

networkInterface.use([{
    applyMiddleware(req, next) {
        let token = localStorage.getItem("authToken");
        if (token) {
            req.options.headers = _.extend(req.options.headers, {
                authorization: `Bearer ${token}`
            });
        }
        next();
    }
}]);

networkInterface.useAfter([{
    applyAfterware({ response }, next) {
        // console.log(response);
        if (response.status === 403) {
            localStorage.removeItem("authToken");
            if (client) {
                client.query({
                    query: gql`
                        query {
                            user {
                                id
                                email
                            }
                        }
                    `
                });
            }
        }
        next();
    }
}]);

ReactDOM.render(
    (
        <ApolloProvider client={client}>
            <BrowserRouter>
                <div className="ij-layout">
                    <Header/>
                    <div className="ij-layout-content ui main container">
                        <Route exact path="/" component={Users}/>
                        <Route path="/user" component={CurrentUser}/>
                        <Route path="/sign-in" component={SignIn}/>
                        <Route path="/sign-in/:token" component={SignIn}/>
                    </div>
                </div>
            </BrowserRouter>
        </ApolloProvider>
    ),
    document.getElementById('root')
);
