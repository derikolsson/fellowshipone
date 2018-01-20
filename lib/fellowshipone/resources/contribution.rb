# frozen_string_literal: true

module Fellowshipone
  class Client
    module Contribution
      def get_contribution(contribution_id)
        get("/giving/v1/contributionreceipts/#{contribution_id}.json")
      end

      def new_contribution
        get('/giving/v1/contributionreceipts/new.json')
      end

      def create_contribution(contribution_params)
        post('/giving/v1/contributionreceipts.json', contribution_params)
      end

      def update_contribution(contribution_id, contribution_params)
        put("/giving/v1/contributionreceipts/#{contribution_id}.json", contribution_params)
      end

      def search_contributions(individual_id: nil, household_id: nil, start_date: nil, end_date: nil, page: 1)
        options = { recordsPerPage: 500 }
        options[:page] = page                    if page
        options[:individualID] = individual_id   if individual_id
        options[:householdID] = household_id     if household_id
        options[:startReceivedDate] = start_date if start_date
        options[:endReceivedDate] = end_date     if end_date

        params = Addressable::URI.form_encode(options)
        response = get("/giving/v1/contributionreceipts/search.json?#{params}").results
        Fellowshipone::Contribution.format(response)
      end
    end
  end
end
