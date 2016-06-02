module Api
  module V1
    class GraphqlController < Api::V1::BaseApiController
      include GraphqlDoc
      
      skip_before_filter :authenticate_from_token!, if: proc { request.options? }
      after_filter :set_access_headers

      def create
        render(text: '') and return if request.options?
        query_string = params[:query]
        query_variables = params[:variables] || {}
        query = GraphQL::Query.new(RelayOnRailsSchema, query_string, variables: query_variables)
        render json: query.result
      end

      private

      def set_access_headers
        headers['Access-Control-Allow-Headers'] = [CONFIG['authorization_header'], 'Content-Type'].join(',')
      end
    end
  end
end
