# frozen_string_literal: true

module Fellowshipone
  class Client
    # Person Realm
    module Person
      def list_people(attrs = {})
        get('/v1/People/Search.json', attrs)
      end

      def find_person(id, follow_merges = false)
        return get("/v1/People/#{id}") unless follow_merges
        resp = get_raw("/v1/People/#{id}")
        resp.on_complete do |resp_env|
          if resp_env.status == 301
            uri = URI(resp_env.response_headers['location'])
            new_id = uri.request_uri.split('/')[3]
            return find_person(new_id, true)
          end
        end
        resp.body
      end

      def new_person
        get('/v1/People/new.json')
      end

      def create_person(person_params)
        post('/v1/People.json', person_params.to_json)
      end

      def update_person(id, person_params)
        put("/v1/People/#{id}.json", person_params.to_json)
      end

      def search_for_person(name: nil, email: nil, include: nil)
        options = {}
        options[:searchfor] = name if name
        options[:communication] = email if email
        options[:include] = include

        params = Addressable::URI.form_encode(options)
        get("/v1/People/Search.json?#{params}").results
      end

      def search_people_by_date(created_at)
        get("/v1/People/Search.json?createdDate=#{created_at}").results
      end

      def search_for_person_by_household(household_id)
        get("/v1/People/Search.json?hsdid=#{household_id}").results
      end

      def search_people_by_barcode(barcode)
        get("/v1/People/Search.json?barCode=#{barcode}").results
      end
    end
  end
end
