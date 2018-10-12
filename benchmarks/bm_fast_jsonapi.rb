# frozen_string_literal: true
require_relative "./benchmarking_support"
require_relative "./app"
require_relative "./setup"


class AmsAuthorFastSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end

class AmsPostFastSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :body, :title, :author_id, :created_at
end

class AmsPostWithHasOneFastSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :body, :title, :author_id

  has_one :author, serializer: AmsAuthorFastSerializer
end

def benchmark_fast_jsonapi(prefix, serializer, options = {})
  merged_options = options

  data = Benchmark.data
  posts = data[:all]
  posts_50 = data[:small]


  Benchmark.run("Fast_JSON_API_#{prefix}_Posts_#{posts.count}") do
    serializer.new(posts, merged_options).serialized_json
  end

  data = Benchmark.data
  posts = data[:all]
  posts_50 = data[:small]

  Benchmark.run("Fast_JSON_API_#{prefix}_Posts_50") do
    serializer.new(posts_50, merged_options).serialized_json
  end
end

benchmark_fast_jsonapi "JsonAPI_Simple", AmsPostFastSerializer
benchmark_fast_jsonapi "JsonAPI_HasOne", AmsPostWithHasOneFastSerializer
benchmark_fast_jsonapi "JsonAPI_Except", AmsPostWithHasOneFastSerializer, except: [:title]
benchmark_fast_jsonapi "JsonAPI_Only", AmsPostWithHasOneFastSerializer, only: [:id, :body, :author_id, :author]
