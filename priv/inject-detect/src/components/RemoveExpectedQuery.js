import Confirm from "./Confirm";
import React from "react";
import _ from "lodash";
import gql from "graphql-tag";
import { ApplicationQuery } from "../graphql";
import { graphql } from "react-apollo";

class Application extends React.Component {

    state = {
        removing: false
    }

    removeExpectedQuery = () => {
        let { application_id, query_id } = this.props;
        this.setState({
            removing: true
        });
        return this.props.removeExpectedQuery(application_id, query_id)
            .catch((err) => {
                console.error(err);
            })
            .then(() => {
                this.setState({
                    removing: false
                });
            });
    }

    render() {
        let { removing } = this.state;

        return (
            <Confirm header="Remove Expected Query?" prompt="Are you sure you want to remove this expected query? Once removed, any other instances of this type of query will be reported as unexpected queries." positive="Remove" negative="Cancel" callback={this.removeExpectedQuery}>
                <button className={`ui icon button`} disabled={removing} data-tooltip="Remove query from set of 'expected queries'." data-position="top right">
                    <i className="trash icon"></i>
                </button>
            </Confirm>
        );
    }
};

const RemoveExpectedQuery = graphql(gql`
    mutation removeExpectedQuery ($application_id: String!, $query_id: String!) {
        removeExpectedQuery(application_id: $application_id, query_id: $query_id) {
            id
            expectedQueries {
                id
            }
        }
    }
`, {
    props: ({ mutate }) => ({
        removeExpectedQuery: (application_id, query_id) => mutate({
            variables: { application_id, query_id },
            refetchQueries: [{
                query: ApplicationQuery,
                variables: { id: application_id }
            }]
        })
    })
});

export default RemoveExpectedQuery(Application);
