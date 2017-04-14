import React from "react";
import _ from "lodash";
import { UserQuery } from "../graphql";
import { graphql } from "react-apollo";

class Dashboard extends React.Component {

    render() {
        let { user } = this.props.data;

        return (

            <div className="ij-dashboard ui mobile reversed stackable grid">
                <div className="nine wide column">

                    { user &&
                        user.applications &&
                        user.applications.map((application) => {
                            return (
                                <div key={application.id}>
                                    <div className="ui stacked segment">
                                        <a className="ui ribbon red label">{application.name}</a>
                                        <i className="right floated protect icon" title="Watching for unexpected queries"></i>
                                        <i className="right floated alarm icon disabled"title="Notifications are not being sent"></i>
                                        <i className="right floated search icon disabled" title="Training mode is turned off"></i>
                                        <div className="ui form">
                                            <table className="ui small very compact unstackable selectable red table">
                                                <tbody>
                                                    <tr>
                                                        <td>Unhandled unexpected queries</td>
                                                        <td className="right aligned"><a href="#"><i className="red warning icon"></i>2</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td>Expected query schemas</td>
                                                        <td className="right aligned">23</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Total queries processed</td>
                                                        <td className="right aligned">10k</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div className="ui hidden divider"></div>
                                </div>
                            );
                        })}

                </div>
                
                <div className="seven wide column">
                    <div className="ui secondary segment">
                        <div className="ui grey small horizontal statistic">
                            <div className="value">
                                100,000
                            </div>
                            <div className="label">
                                Credits Left
                            </div>
                        </div>
                        <div className="ui orange progress" data-value="50" data-total="100">
                            <div className="bar">
                                <div className="progress"></div>
                            </div>
                        </div>
                    </div>
                    <table className="ui small very compact unstackable selectable olive table">
                        <thead>
                            <tr>
                                <th colSpan="2">
                                    Recent activity
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr>
                                <td>Unhandled unexpected queries</td>
                                <td className="right aligned" title="20,045 queries processed"><i className="red warning icon"></i>2</td>
                            </tr>
                            <tr>
                                <td>Total queries processed</td>
                                <td className="right aligned" title="20,045 queries processed">20.2k</td>
                            </tr>
                            <tr>
                                <td>Unrecognized queries detected</td>
                                <td className="right aligned" title="430 unrecognized queries detectd">430</td>
                            </tr>
                            <tr>
                                <td>Credits used</td>
                                <td className="right aligned" title="2,013 credits used">2k</td>
                            </tr>
                            
                        </tbody>
                    </table>

                    <table className="ui small very compact unstackable selectable orange table">
                        <thead>
                            <tr>
                                <th colSpan="1">
                                    Quick links
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr>
                                <td><i className="plus icon"></i><a href="#" className="">Add application</a></td>
                            </tr>
                            <tr>
                                <td><i className="dollar icon"></i><a href="#" className="">Buy more credits</a></td>
                            </tr>
                            <tr>
                                <td><i className="refresh icon"></i><a href="#" className="">Credit auto-fill</a></td>
                            </tr>
                            <tr>
                                <td><i className="user icon"></i><a href="#" className="">Edit account</a></td>
                            </tr>
                        </tbody>
                    </table>

                </div>
                
            </div>
        );
    }
};

export default graphql(UserQuery)(Dashboard);
