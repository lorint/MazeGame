class PositionsController < ApplicationController
	def create
		game = Game.find(params[:game_id])
		Position.create(position_params.merge(game_id: game.id, user_id: current_user.id))

		positions = Position.find_by_sql("SELECT * FROM positions WHERE id IN (SELECT MAX(id) FROM positions WHERE game_id = #{game.id} GROUP BY user_id);")

		players = []
		positions.each do |position|
			left = (position.lat - game.lat1) / (game.lat2 - game.lat1) * 100.0
			top = (position.lng - game.lng1) / (game.lng2 - game.lng1) * 100.0
			players << {id: position.user_id, name: position.user.name, left: left, top: top}
		end

		# Return all cached positions
		render json: players
	end

	private
    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:lat, :lng, :accuracy)
    end
end
