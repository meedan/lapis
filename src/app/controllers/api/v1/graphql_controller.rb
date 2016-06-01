module Api
  module V1
    class GraphqlController < Api::V1::BaseApiController
      include GraphqlDoc
      def create
        query_string = params[:query]
        query_variables = params[:variables] || {}
        query = GraphQL::Query.new(RelayOnRailsSchema, query_string, variables: query_variables)
        render json: query.result
      end
    end
  end
end
