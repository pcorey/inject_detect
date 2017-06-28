import './styles/index.styl';
import Account from './components/Account';
import Application from './components/Application';
import Dashboard from './components/Dashboard';
import GetStarted from './components/GetStarted';
import Header from './components/Header';
import PrivateRoute from './components/PrivateRoute';
import React from 'react';
import ReactDOM from 'react-dom';
import ScrollToTop from './components/ScrollToTop';
import SignIn from './components/SignIn';
import UnexpectedQuery from './components/UnexpectedQuery';
import VerifyRequestedToken from './components/VerifyRequestedToken';
import Unsubscribe from './components/Unsubscribe';
import _ from 'lodash';
import { ApolloProvider } from 'react-apollo';
import { BrowserRouter, Route } from 'react-router-dom';
import { client } from './apollo';

ReactDOM.render(
    <ApolloProvider client={client}>
        <BrowserRouter onUpdate={() => window.scrollTo(0, 0)}>
            <ScrollToTop>
                <div className="ij-layout">
                    <Header />
                    <div className="ij-layout-content ui main container">
                        <Route path="/sign-in" component={SignIn} />
                        <Route path="/get-started" component={GetStarted} />
                        <Route path="/verify/:token" component={VerifyRequestedToken} />
                        <Route path="/unsubscribe/:token" component={Unsubscribe} />
                        <PrivateRoute exact path="/" component={Dashboard} />
                        <PrivateRoute path="/account" component={Account} />
                        <PrivateRoute path="/application/:id" component={Application} />
                        <PrivateRoute path="/unexpected-query/:id" component={UnexpectedQuery} />
                    </div>
                </div>
            </ScrollToTop>
        </BrowserRouter>
    </ApolloProvider>,
    document.getElementById('root')
);
