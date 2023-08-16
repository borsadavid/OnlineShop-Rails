class ProductQrsController < ApplicationController
	
  def add_review #same function for adding a question 
      processed_order = ProcessedOrder.find_by(account_id: current_account.id, product_id: params[:product_id])
      @product_review = ProductQr.find_by(account_id: current_account.id, product_id: params[:product_id], is_review: true)

      if params[:is_review].present? && params[:is_review] == "false" #case of question placed
        product_question = ProductQr.new(
          account_id: current_account.id,
          product_id: params[:product_id],
          text: params[:review_text],
          is_review: false #no params passed means it's a review
        )
        product_question.save
        OrderMailer.new_question(params[:product_id], product_question).deliver_now #send mail for new question
        return redirect_to product_path(params[:product_id]), notice: "Review Added"
      end

      if @product_review    #case of review placed
        return redirect_to product_path(params[:product_id]), notice: "You can only place 1 review per product."
      elsif processed_order
        product_review = ProductQr.new(
          account_id: current_account.id,
          product_id: params[:product_id],
          stars: params[:review][:stars],
          text: params[:review_text],
        )
        product_review.save
        redirect_to product_path(params[:product_id]), notice: "Review Added"
      else 
        redirect_to product_path(params[:product_id]), notice: "You must order the product in order to place a review."
      end
  end

  def add_comment #same for adding answer
     if current_account.role == 'admin'
      @review = ProductQr.find(params[:id])
      @review.comment = params[:comment_text]
      @review.save
      redirect_to product_path(params[:product_id]), notice: "Comment added."
      end
  end

  def delete_comment 
     if current_account.role == 'admin'
     @review = ProductQr.find(params[:id])
     @review.comment = nil
     @review.save
     redirect_to product_path(@review.product_id), notice: "Comment deleted."
     end
  end

    def	delete_review #same with delete question
        @review = ProductQr.find(params[:id])
        if @review.account_id == current_account.id
          if @review.destroy
            redirect_to product_path(@review.product_id), notice: "Review successfully deleted."
          else
            redirect_to product_path(@review.product_id), alert: "Failed to delete the review."
          end
        end
    end

end  
