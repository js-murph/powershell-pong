Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Ticker() {
  if ($script:bPlayer1MoveUp) {
    if (($script:imgPlayer1Paddle.Location.Y - 7) -gt 0) {
      $intCurrentX = $script:imgPlayer1Paddle.Location.X
      $intCurrentY = $script:imgPlayer1Paddle.Location.Y
      $intNewY = $intCurrentY - 7
      $script:imgPlayer1Paddle.Location = New-Object System.Drawing.Point($intCurrentX, $intNewY)
    }
  }

  if ($script:bPlayer1MoveDown) {
    if (($script:imgPlayer1Paddle.Location.Y + $script:imgPlayer1Paddle.Height + 7) -lt $script:frmPong.Height) {
      $intCurrentX = $script:imgPlayer1Paddle.Location.X
      $intCurrentY = $script:imgPlayer1Paddle.Location.Y
      $intNewY = $intCurrentY + 7
      $script:imgPlayer1Paddle.Location = New-Object System.Drawing.Point($intCurrentX, $intNewY)
    }
  }

  if ($script:bPlayer2MoveUp) {
    if (($script:imgPlayer2Paddle.Location.Y - 7) -gt 0) {
      $intCurrentX = $script:imgPlayer2Paddle.Location.X
      $intCurrentY = $script:imgPlayer2Paddle.Location.Y
      $intNewY = $intCurrentY - 7
      $script:imgPlayer2Paddle.Location = New-Object System.Drawing.Point($intCurrentX, $intNewY)
    }
  }

  if ($script:bPlayer2MoveDown) {
    if (($script:imgPlayer2Paddle.Location.Y + $script:imgPlayer2Paddle.Height + 7) -lt $script:frmPong.Height) {
      $intCurrentX = $script:imgPlayer2Paddle.Location.X
      $intCurrentY = $script:imgPlayer2Paddle.Location.Y
      $intNewY = $intCurrentY + 7
      $script:imgPlayer2Paddle.Location = New-Object System.Drawing.Point($intCurrentX, $intNewY)
    }
  }

  $intBallNewX = $script:imgBall.Location.X + $script:intBallVelX
  $intBallNewY = $script:imgBall.Location.Y + $script:intBallVelY
  $script:imgBall.Location = New-Object System.Drawing.Point($intBallNewX, $intBallNewY)

  if ($script:imgBall.Location.Y -le 0) {
    $script:imgBall.Location = New-Object System.Drawing.Point($script:imgBall.Location.X, 0)
    $script:intBallVelY = -$script:intBallVelY
  } elseif (($script:imgBall.Location.Y + $script:imgBall.Height) -ge $script:frmPong.Height) {
    $intNewY = $script:frmPong.Height - $script:imgBall.Height
    $script:imgBall.Location = New-Object System.Drawing.Point($script:imgBall.Location.X, $intNewY)
    $script:intBallVelY = -$script:intBallVelY
  }

  if ($script:imgBall.Bounds.IntersectsWith($script:imgPlayer1Paddle.Bounds)) {
    $intNewX = $script:imgPlayer1Paddle.Location.X + $script:imgBall.Width
    $script:imgBall.Location = New-Object System.Drawing.Point($intNewX, $script:imgBall.Location.Y)
    $script:intBallVelX = -$script:intBallVelX
  } elseif ($script:imgBall.Bounds.IntersectsWith($script:imgPlayer2Paddle.Bounds)) {
    $intNewX = $script:imgPlayer2Paddle.Location.X - $script:imgBall.Width
    $script:imgBall.Location = New-Object System.Drawing.Point($intNewX, $script:imgBall.Location.Y)
    $script:intBallVelX = -$script:intBallVelX
  }

  if ($script:imgBall.Location.X -le 0) {
    $script:intPlayer2Score += 1
    $script:lblPlayer2Score.Text = $script:intPlayer2Score

    $intBallLocX = ($frmPong.Width / 2) - ($imgBall.Width / 2)
    $intBallLocY = ($frmPong.Height / 2) - ($imgBall.Height / 2)
    $script:imgBall.Location = New-Object System.Drawing.Point($intBallLocX, $intBallLocY)
  } elseif (($script:imgBall.Location.X + $script:imgBall.Width) -ge $script:frmPong.Width) {
    $script:intPlayer1Score += 1
    $script:lblPlayer1Score.Text = $script:intPlayer1Score

    $intBallLocX = ($frmPong.Width / 2) - ($imgBall.Width / 2)
    $intBallLocY = ($frmPong.Height / 2) - ($imgBall.Height / 2)
    $script:imgBall.Location = New-Object System.Drawing.Point($intBallLocX, $intBallLocY)
  }
}

function KeyDownHandler($keyEvent) {
  if ($keyEvent.KeyCode -eq "Escape") {
    $script:frmPong.Close()
  } elseif ($keyEvent.KeyCode -eq "W") {
    $script:bPlayer1MoveUp = $true
  } elseif ($keyEvent.KeyCode -eq "S") {
    $script:bPlayer1MoveDown = $true
  } elseif ($keyEvent.KeyCode -eq "O") {
    $script:bPlayer2MoveUp = $true
  } elseif ($keyEvent.KeyCode -eq "L") {
    $script:bPlayer2MoveDown = $true
  } elseif ($keyEvent.KeyCode -eq "Space") {
    $script:tmrTicker.Enabled = $true
  }
}

function KeyUpHandler($keyEvent) {
  if ($keyEvent.KeyCode -eq "W") {
    $script:bPlayer1MoveUp = $false
  } elseif ($keyEvent.KeyCode -eq "S") {
    $script:bPlayer1MoveDown = $false
  } elseif ($keyEvent.KeyCode -eq "O") {
    $script:bPlayer2MoveUp = $false
  } elseif ($keyEvent.KeyCode -eq "L") {
    $script:bPlayer2MoveDown = $false
  }
}

################
# MAIN
################
$frmPong = New-Object System.Windows.Forms.Form
$frmPong.Width = 640
$frmPong.Height = 480
$frmPong.Text = "Pong!"
$frmPong.BackColor = "Black"
$frmPong.FormBorderStyle = "None"
$frmPong.MaximizeBox = $false
$frmPong.MinimizeBox = $false
$frmPong.StartPosition = "CenterScreen"
$frmPong.KeyPreview = $true
$frmPong.Add_KeyDown({KeyDownHandler($_)})
$frmPong.Add_KeyUp({KeyUpHandler($_)})

$intPlayer1Score = 0
$intPlayer2Score = 0
$bPlayer1MoveUp = $false
$bPlayer1MoveDown = $false
$bPlayer2MoveUp = $false
$bPlayer2MoveDown = $false

$intBallSpeed = 7
$rndBallRand = New-Object System.Random
$intBallVelX = [System.Math]::Cos($rndBallRand.Next(5, 10)) * $intBallSpeed
$intBallVelY = [System.Math]::Sin($rndBallRand.Next(5, 10)) * $intBallSpeed

$imgBall = New-Object System.Windows.Forms.PictureBox
$imgBall.Width = 20
$imgBall.Height = 20
$imgBall.BackColor = "White"
$intBallLocX = ($frmPong.Width / 2) - ($imgBall.Width / 2)
$intBallLocY = ($frmPong.Height / 2) - ($imgBall.Height / 2)
$imgBall.Location = New-Object System.Drawing.Point($intBallLocX, $intBallLocY)

$imgPlayer1Paddle = New-Object System.Windows.Forms.PictureBox
$imgPlayer1Paddle.Width = 16
$imgPlayer1Paddle.Height = 128
$imgPlayer1Paddle.BackColor = "White"
$intPlayer1PaddleY = ($frmPong.Height / 2) - ($imgPlayer1Paddle.Height / 2)
$imgPlayer1Paddle.Location = New-Object System.Drawing.Point(20,$intPlayer1PaddleY)

$imgPlayer2Paddle = New-Object System.Windows.Forms.PictureBox
$imgPlayer2Paddle.Width = 16
$imgPlayer2Paddle.Height = 128
$imgPlayer2Paddle.BackColor = "White"
$intPlayer2PaddleX = $frmPong.Width - ($imgPlayer2Paddle.Width + 20)
$intPlayer2PaddleY = ($frmPong.Height / 2) - ($imgPlayer1Paddle.Height / 2)
$imgPlayer2Paddle.Location = New-Object System.Drawing.Point($intPlayer2PaddleX, $intPlayer2PaddleY)

$lblPlayer1Score = New-Object System.Windows.Forms.Label
$lblPlayer1Score.Text = $intPlayer1Score
$lblPlayer1Score.TextAlign = "MiddleCenter"
$lblPlayer1Score.Font = New-Object System.Drawing.Font("times new roman", 20)
$lblPlayer1Score.Width = 50
$lblPlayer1Score.Height = 50
$lblPlayer1Score.ForeColor = "White"
$lblPlayer1Score.Location = New-Object System.Drawing.Point(0,0)

$lblPlayer2Score = New-Object System.Windows.Forms.Label
$lblPlayer2Score.Text = $intPlayer2Score
$lblPlayer2Score.TextAlign = "MiddleCenter"
$lblPlayer2Score.Font = New-Object System.Drawing.Font("times new roman", 20)
$lblPlayer2Score.Width = 50
$lblPlayer2Score.Height = 50
$lblPlayer2Score.ForeColor = "White"
$intPlayer2ScoreX = $frmPong.Width - $lblPlayer2Score.Width
$lblPlayer2Score.Location = New-Object System.Drawing.Point($intPlayer2ScoreX,0)

$tmrTicker = New-Object System.Windows.Forms.Timer
$tmrTicker.Interval = 5
$tmrTicker.Enabled = $false
$tmrTicker.Add_Tick({Ticker})

$frmPong.Controls.Add($imgBall)
$frmPong.Controls.Add($imgPlayer1Paddle)
$frmPong.Controls.Add($imgPlayer2Paddle)
$frmPong.Controls.Add($lblPlayer1Score)
$frmPong.Controls.Add($lblPlayer2Score)
$frmPong.ShowDialog()
