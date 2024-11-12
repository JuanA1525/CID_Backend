class DashboardService
  def self.get_dashboard_data
    {
      data: {
        users: User.count,
        posts: Post.count,
        comments: Comment.count
      },
      status: :ok
    }
  end
end
