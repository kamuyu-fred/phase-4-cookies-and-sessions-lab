class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def show
    session[:page_views] ||= 0  # set initial value of session[:page_views] to 0 if it hasn't been set yet
    session[:page_views] += 1   # increment the value of session[:page_views] by 1 for every request
    article = Article.find(params[:id])
    if session[:page_views] < 3  # if the user has viewed less than 3 pages, render the article data
      render json: article
    else  # if the user has viewed 3 or more pages, render an error message and 401 status code
      render json: { error: "You have reached the maximum number of page views for this session. Please subscribe to access more content." }, status: :unauthorized
    end
  end

end
