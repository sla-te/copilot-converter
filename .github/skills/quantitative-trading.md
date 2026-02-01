# Quantitative Trading Guidelines

You are a quantitative analyst specializing in algorithmic trading and financial modeling.

## Focus Areas

- Trading strategy development and backtesting
- Risk metrics (VaR, Sharpe ratio, max drawdown)
- Portfolio optimization (Markowitz, Black-Litterman)
- Time series analysis and forecasting
- Options pricing and Greeks calculation
- Statistical arbitrage and pairs trading

## Approach

1. Data quality first - clean and validate all inputs
2. Robust backtesting with transaction costs and slippage
3. Risk-adjusted returns over absolute returns
4. Out-of-sample testing to avoid overfitting
5. Clear separation of research and production code

## Output

- Strategy implementation with vectorized operations
- Backtest results with performance metrics
- Risk analysis and exposure reports
- Data pipeline for market data ingestion
- Visualization of returns and key metrics
- Parameter sensitivity analysis

Use pandas, numpy, and scipy. Include realistic assumptions about market microstructure.

These guidelines provide practices for quantitative trading.

## Backtesting Frameworks

# Backtesting Frameworks

Build robust, production-grade backtesting systems that avoid common pitfalls and produce reliable strategy performance estimates.

## When to Use This Skill

- Developing trading strategy backtests
- Building backtesting infrastructure
- Validating strategy performance
- Avoiding common backtesting biases
- Implementing walk-forward analysis
- Comparing strategy alternatives

## Core Concepts

### 1. Backtesting Biases

| Bias             | Description               | Mitigation              |
| ---------------- | ------------------------- | ----------------------- |
| **Look-ahead**   | Using future information  | Point-in-time data      |
| **Survivorship** | Only testing on survivors | Use delisted securities |
| **Overfitting**  | Curve-fitting to history  | Out-of-sample testing   |
| **Selection**    | Cherry-picking strategies | Pre-registration        |
| **Transaction**  | Ignoring trading costs    | Realistic cost models   |

### 2. Proper Backtest Structure

```
Historical Data
      │
      ▼
┌─────────────────────────────────────────┐
│              Training Set               │
│  (Strategy Development & Optimization)  │
└─────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────┐
│             Validation Set              │
│  (Parameter Selection, No Peeking)      │
└─────────────────────────────────────────┘
      │
      ▼
┌─────────────────────────────────────────┐
│               Test Set                  │
│  (Final Performance Evaluation)         │
└─────────────────────────────────────────┘
```

### 3. Walk-Forward Analysis

```
Window 1: [Train──────][Test]
Window 2:     [Train──────][Test]
Window 3:         [Train──────][Test]
Window 4:             [Train──────][Test]
                                     ─────▶ Time
```

## Implementation Patterns

### Pattern 1: Event-Driven Backtester

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import Dict, List, Optional
import pandas as pd
import numpy as np

class OrderSide(Enum):
    BUY = "buy"
    SELL = "sell"

class OrderType(Enum):
    MARKET = "market"
    LIMIT = "limit"
    STOP = "stop"

@dataclass
class Order:
    symbol: str
    side: OrderSide
    quantity: Decimal
    order_type: OrderType
    limit_price: Optional[Decimal] = None
    stop_price: Optional[Decimal] = None
    timestamp: Optional[datetime] = None

@dataclass
class Fill:
    order: Order
    fill_price: Decimal
    fill_quantity: Decimal
    commission: Decimal
    slippage: Decimal
    timestamp: datetime

@dataclass
class Position:
    symbol: str
    quantity: Decimal = Decimal("0")
    avg_cost: Decimal = Decimal("0")
    realized_pnl: Decimal = Decimal("0")

    def update(self, fill: Fill) -> None:
        if fill.order.side == OrderSide.BUY:
            new_quantity = self.quantity + fill.fill_quantity
            if new_quantity != 0:
                self.avg_cost = (
                    (self.quantity * self.avg_cost + fill.fill_quantity * fill.fill_price)
                    / new_quantity
                )
            self.quantity = new_quantity
        else:
            self.realized_pnl += fill.fill_quantity * (fill.fill_price - self.avg_cost)
            self.quantity -= fill.fill_quantity

@dataclass
class Portfolio:
    cash: Decimal
    positions: Dict[str, Position] = field(default_factory=dict)

    def get_position(self, symbol: str) -> Position:
        if symbol not in self.positions:
            self.positions[symbol] = Position(symbol=symbol)
        return self.positions[symbol]

    def process_fill(self, fill: Fill) -> None:
        position = self.get_position(fill.order.symbol)
        position.update(fill)

        if fill.order.side == OrderSide.BUY:
            self.cash -= fill.fill_price * fill.fill_quantity + fill.commission
        else:
            self.cash += fill.fill_price * fill.fill_quantity - fill.commission

    def get_equity(self, prices: Dict[str, Decimal]) -> Decimal:
        equity = self.cash
        for symbol, position in self.positions.items():
            if position.quantity != 0 and symbol in prices:
                equity += position.quantity * prices[symbol]
        return equity

class Strategy(ABC):
    @abstractmethod
    def on_bar(self, timestamp: datetime, data: pd.DataFrame) -> List[Order]:
        pass

    @abstractmethod
    def on_fill(self, fill: Fill) -> None:
        pass

class ExecutionModel(ABC):
    @abstractmethod
    def execute(self, order: Order, bar: pd.Series) -> Optional[Fill]:
        pass

class SimpleExecutionModel(ExecutionModel):
    def __init__(self, slippage_bps: float = 10, commission_per_share: float = 0.01):
        self.slippage_bps = slippage_bps
        self.commission_per_share = commission_per_share

    def execute(self, order: Order, bar: pd.Series) -> Optional[Fill]:
        if order.order_type == OrderType.MARKET:
            base_price = Decimal(str(bar["open"]))

            # Apply slippage
            slippage_mult = 1 + (self.slippage_bps / 10000)
            if order.side == OrderSide.BUY:
                fill_price = base_price * Decimal(str(slippage_mult))
            else:
                fill_price = base_price / Decimal(str(slippage_mult))

            commission = order.quantity * Decimal(str(self.commission_per_share))
            slippage = abs(fill_price - base_price) * order.quantity

            return Fill(
                order=order,
                fill_price=fill_price,
                fill_quantity=order.quantity,
                commission=commission,
                slippage=slippage,
                timestamp=bar.name
            )
        return None

class Backtester:
    def __init__(
        self,
        strategy: Strategy,
        execution_model: ExecutionModel,
        initial_capital: Decimal = Decimal("100000")
    ):
        self.strategy = strategy
        self.execution_model = execution_model
        self.portfolio = Portfolio(cash=initial_capital)
        self.equity_curve: List[tuple] = []
        self.trades: List[Fill] = []

    def run(self, data: pd.DataFrame) -> pd.DataFrame:
        """Run backtest on OHLCV data with DatetimeIndex."""
        pending_orders: List[Order] = []

        for timestamp, bar in data.iterrows():
            # Execute pending orders at today's prices
            for order in pending_orders:
                fill = self.execution_model.execute(order, bar)
                if fill:
                    self.portfolio.process_fill(fill)
                    self.strategy.on_fill(fill)
                    self.trades.append(fill)

            pending_orders.clear()

            # Get current prices for equity calculation
            prices = {data.index.name or "default": Decimal(str(bar["close"]))}
            equity = self.portfolio.get_equity(prices)
            self.equity_curve.append((timestamp, float(equity)))

            # Generate new orders for next bar
            new_orders = self.strategy.on_bar(timestamp, data.loc[:timestamp])
            pending_orders.extend(new_orders)

        return self._create_results()

    def _create_results(self) -> pd.DataFrame:
        equity_df = pd.DataFrame(self.equity_curve, columns=["timestamp", "equity"])
        equity_df.set_index("timestamp", inplace=True)
        equity_df["returns"] = equity_df["equity"].pct_change()
        return equity_df
```

### Pattern 2: Vectorized Backtester (Fast)

```python
import pandas as pd
import numpy as np
from typing import Callable, Dict, Any

class VectorizedBacktester:
    """Fast vectorized backtester for simple strategies."""

    def __init__(
        self,
        initial_capital: float = 100000,
        commission: float = 0.001,  # 0.1%
        slippage: float = 0.0005   # 0.05%
    ):
        self.initial_capital = initial_capital
        self.commission = commission
        self.slippage = slippage

    def run(
        self,
        prices: pd.DataFrame,
        signal_func: Callable[[pd.DataFrame], pd.Series]
    ) -> Dict[str, Any]:
        """
        Run backtest with signal function.

        Args:
            prices: DataFrame with 'close' column
            signal_func: Function that returns position signals (-1, 0, 1)

        Returns:
            Dictionary with results
        """
        # Generate signals (shifted to avoid look-ahead)
        signals = signal_func(prices).shift(1).fillna(0)

        # Calculate returns
        returns = prices["close"].pct_change()

        # Calculate strategy returns with costs
        position_changes = signals.diff().abs()
        trading_costs = position_changes * (self.commission + self.slippage)

        strategy_returns = signals * returns - trading_costs

        # Build equity curve
        equity = (1 + strategy_returns).cumprod() * self.initial_capital

        # Calculate metrics
        results = {
            "equity": equity,
            "returns": strategy_returns,
            "signals": signals,
            "metrics": self._calculate_metrics(strategy_returns, equity)
        }

        return results

    def _calculate_metrics(
        self,
        returns: pd.Series,
        equity: pd.Series
    ) -> Dict[str, float]:
        """Calculate performance metrics."""
        total_return = (equity.iloc[-1] / self.initial_capital) - 1
        annual_return = (1 + total_return) ** (252 / len(returns)) - 1
        annual_vol = returns.std() * np.sqrt(252)
        sharpe = annual_return / annual_vol if annual_vol > 0 else 0

        # Drawdown
        rolling_max = equity.cummax()
        drawdown = (equity - rolling_max) / rolling_max
        max_drawdown = drawdown.min()

        # Win rate
        winning_days = (returns > 0).sum()
        total_days = (returns != 0).sum()
        win_rate = winning_days / total_days if total_days > 0 else 0

        return {
            "total_return": total_return,
            "annual_return": annual_return,
            "annual_volatility": annual_vol,
            "sharpe_ratio": sharpe,
            "max_drawdown": max_drawdown,
            "win_rate": win_rate,
            "num_trades": int((returns != 0).sum())
        }

# Example usage
def momentum_signal(prices: pd.DataFrame, lookback: int = 20) -> pd.Series:
    """Simple momentum strategy: long when price > SMA, else flat."""
    sma = prices["close"].rolling(lookback).mean()
    return (prices["close"] > sma).astype(int)

# Run backtest
# backtester = VectorizedBacktester()
# results = backtester.run(price_data, lambda p: momentum_signal(p, 50))
```

### Pattern 3: Walk-Forward Optimization

```python
from typing import Callable, Dict, List, Tuple, Any
import pandas as pd
import numpy as np
from itertools import product

class WalkForwardOptimizer:
    """Walk-forward analysis with anchored or rolling windows."""

    def __init__(
        self,
        train_period: int,
        test_period: int,
        anchored: bool = False,
        n_splits: int = None
    ):
        """
        Args:
            train_period: Number of bars in training window
            test_period: Number of bars in test window
            anchored: If True, training always starts from beginning
            n_splits: Number of train/test splits (auto-calculated if None)
        """
        self.train_period = train_period
        self.test_period = test_period
        self.anchored = anchored
        self.n_splits = n_splits

    def generate_splits(
        self,
        data: pd.DataFrame
    ) -> List[Tuple[pd.DataFrame, pd.DataFrame]]:
        """Generate train/test splits."""
        splits = []
        n = len(data)

        if self.n_splits:
            step = (n - self.train_period) // self.n_splits
        else:
            step = self.test_period

        start = 0
        while start + self.train_period + self.test_period <= n:
            if self.anchored:
                train_start = 0
            else:
                train_start = start

            train_end = start + self.train_period
            test_end = min(train_end + self.test_period, n)

            train_data = data.iloc[train_start:train_end]
            test_data = data.iloc[train_end:test_end]

            splits.append((train_data, test_data))
            start += step

        return splits

    def optimize(
        self,
        data: pd.DataFrame,
        strategy_func: Callable,
        param_grid: Dict[str, List],
        metric: str = "sharpe_ratio"
    ) -> Dict[str, Any]:
        """
        Run walk-forward optimization.

        Args:
            data: Full dataset
            strategy_func: Function(data, **params) -> results dict
            param_grid: Parameter combinations to test
            metric: Metric to optimize

        Returns:
            Combined results from all test periods
        """
        splits = self.generate_splits(data)
        all_results = []
        optimal_params_history = []

        for i, (train_data, test_data) in enumerate(splits):
            # Optimize on training data
            best_params, best_metric = self._grid_search(
                train_data, strategy_func, param_grid, metric
            )
            optimal_params_history.append(best_params)

            # Test with optimal params
            test_results = strategy_func(test_data, **best_params)
            test_results["split"] = i
            test_results["params"] = best_params
            all_results.append(test_results)

            print(f"Split {i+1}/{len(splits)}: "
                  f"Best {metric}={best_metric:.4f}, params={best_params}")

        return {
            "split_results": all_results,
            "param_history": optimal_params_history,
            "combined_equity": self._combine_equity_curves(all_results)
        }

    def _grid_search(
        self,
        data: pd.DataFrame,
        strategy_func: Callable,
        param_grid: Dict[str, List],
        metric: str
    ) -> Tuple[Dict, float]:
        """Grid search for best parameters."""
        best_params = None
        best_metric = -np.inf

        # Generate all parameter combinations
        param_names = list(param_grid.keys())
        param_values = list(param_grid.values())

        for values in product(*param_values):
            params = dict(zip(param_names, values))
            results = strategy_func(data, **params)

            if results["metrics"][metric] > best_metric:
                best_metric = results["metrics"][metric]
                best_params = params

        return best_params, best_metric

    def _combine_equity_curves(
        self,
        results: List[Dict]
    ) -> pd.Series:
        """Combine equity curves from all test periods."""
        combined = pd.concat([r["equity"] for r in results])
        return combined
```

### Pattern 4: Monte Carlo Analysis

```python
import numpy as np
import pandas as pd
from typing import Dict, List

class MonteCarloAnalyzer:
    """Monte Carlo simulation for strategy robustness."""

    def __init__(self, n_simulations: int = 1000, confidence: float = 0.95):
        self.n_simulations = n_simulations
        self.confidence = confidence

    def bootstrap_returns(
        self,
        returns: pd.Series,
        n_periods: int = None
    ) -> np.ndarray:
        """
        Bootstrap simulation by resampling returns.

        Args:
            returns: Historical returns series
            n_periods: Length of each simulation (default: same as input)

        Returns:
            Array of shape (n_simulations, n_periods)
        """
        if n_periods is None:
            n_periods = len(returns)

        simulations = np.zeros((self.n_simulations, n_periods))

        for i in range(self.n_simulations):
            # Resample with replacement
            simulated_returns = np.random.choice(
                returns.values,
                size=n_periods,
                replace=True
            )
            simulations[i] = simulated_returns

        return simulations

    def analyze_drawdowns(
        self,
        returns: pd.Series
    ) -> Dict[str, float]:
        """Analyze drawdown distribution via simulation."""
        simulations = self.bootstrap_returns(returns)

        max_drawdowns = []
        for sim_returns in simulations:
            equity = (1 + sim_returns).cumprod()
            rolling_max = np.maximum.accumulate(equity)
            drawdowns = (equity - rolling_max) / rolling_max
            max_drawdowns.append(drawdowns.min())

        max_drawdowns = np.array(max_drawdowns)

        return {
            "expected_max_dd": np.mean(max_drawdowns),
            "median_max_dd": np.median(max_drawdowns),
            f"worst_{int(self.confidence*100)}pct": np.percentile(
                max_drawdowns, (1 - self.confidence) * 100
            ),
            "worst_case": max_drawdowns.min()
        }

    def probability_of_loss(
        self,
        returns: pd.Series,
        holding_periods: List[int] = [21, 63, 126, 252]
    ) -> Dict[int, float]:
        """Calculate probability of loss over various holding periods."""
        results = {}

        for period in holding_periods:
            if period > len(returns):
                continue

            simulations = self.bootstrap_returns(returns, period)
            total_returns = (1 + simulations).prod(axis=1) - 1
            prob_loss = (total_returns < 0).mean()
            results[period] = prob_loss

        return results

    def confidence_interval(
        self,
        returns: pd.Series,
        periods: int = 252
    ) -> Dict[str, float]:
        """Calculate confidence interval for future returns."""
        simulations = self.bootstrap_returns(returns, periods)
        total_returns = (1 + simulations).prod(axis=1) - 1

        lower = (1 - self.confidence) / 2
        upper = 1 - lower

        return {
            "expected": total_returns.mean(),
            "lower_bound": np.percentile(total_returns, lower * 100),
            "upper_bound": np.percentile(total_returns, upper * 100),
            "std": total_returns.std()
        }
```

## Performance Metrics

```python
def calculate_metrics(returns: pd.Series, rf_rate: float = 0.02) -> Dict[str, float]:
    """Calculate comprehensive performance metrics."""
    # Annualization factor (assuming daily returns)
    ann_factor = 252

    # Basic metrics
    total_return = (1 + returns).prod() - 1
    annual_return = (1 + total_return) ** (ann_factor / len(returns)) - 1
    annual_vol = returns.std() * np.sqrt(ann_factor)

    # Risk-adjusted returns
    sharpe = (annual_return - rf_rate) / annual_vol if annual_vol > 0 else 0

    # Sortino (downside deviation)
    downside_returns = returns[returns < 0]
    downside_vol = downside_returns.std() * np.sqrt(ann_factor)
    sortino = (annual_return - rf_rate) / downside_vol if downside_vol > 0 else 0

    # Calmar ratio
    equity = (1 + returns).cumprod()
    rolling_max = equity.cummax()
    drawdowns = (equity - rolling_max) / rolling_max
    max_drawdown = drawdowns.min()
    calmar = annual_return / abs(max_drawdown) if max_drawdown != 0 else 0

    # Win rate and profit factor
    wins = returns[returns > 0]
    losses = returns[returns < 0]
    win_rate = len(wins) / len(returns[returns != 0]) if len(returns[returns != 0]) > 0 else 0
    profit_factor = wins.sum() / abs(losses.sum()) if losses.sum() != 0 else np.inf

    return {
        "total_return": total_return,
        "annual_return": annual_return,
        "annual_volatility": annual_vol,
        "sharpe_ratio": sharpe,
        "sortino_ratio": sortino,
        "calmar_ratio": calmar,
        "max_drawdown": max_drawdown,
        "win_rate": win_rate,
        "profit_factor": profit_factor,
        "num_trades": int((returns != 0).sum())
    }
```

## Best Practices

### Do's

- **Use point-in-time data** - Avoid look-ahead bias
- **Include transaction costs** - Realistic estimates
- **Test out-of-sample** - Always reserve data
- **Use walk-forward** - Not just train/test
- **Monte Carlo analysis** - Understand uncertainty

### Don'ts

- **Don't overfit** - Limit parameters
- **Don't ignore survivorship** - Include delisted
- **Don't use adjusted data carelessly** - Understand adjustments
- **Don't optimize on full history** - Reserve test set
- **Don't ignore capacity** - Market impact matters

## Resources

- [Advances in Financial Machine Learning (Marcos López de Prado)](https://www.amazon.com/Advances-Financial-Machine-Learning-Marcos/dp/1119482089)
- [Quantitative Trading (Ernest Chan)](https://www.amazon.com/Quantitative-Trading-Build-Algorithmic-Business/dp/1119800064)
- [Backtrader Documentation](https://www.backtrader.com/docu/)

## Risk Metrics Calculation

# Risk Metrics Calculation

Comprehensive risk measurement toolkit for portfolio management, including Value at Risk, Expected Shortfall, and drawdown analysis.

## When to Use This Skill

- Measuring portfolio risk
- Implementing risk limits
- Building risk dashboards
- Calculating risk-adjusted returns
- Setting position sizes
- Regulatory reporting

## Core Concepts

### 1. Risk Metric Categories

| Category          | Metrics         | Use Case             |
| ----------------- | --------------- | -------------------- |
| **Volatility**    | Std Dev, Beta   | General risk         |
| **Tail Risk**     | VaR, CVaR       | Extreme losses       |
| **Drawdown**      | Max DD, Calmar  | Capital preservation |
| **Risk-Adjusted** | Sharpe, Sortino | Performance          |

### 2. Time Horizons

```
Intraday:   Minute/hourly VaR for day traders
Daily:      Standard risk reporting
Weekly:     Rebalancing decisions
Monthly:    Performance attribution
Annual:     Strategic allocation
```

## Implementation

### Pattern 1: Core Risk Metrics

```python
import numpy as np
import pandas as pd
from scipy import stats
from typing import Dict, Optional, Tuple

class RiskMetrics:
    """Core risk metric calculations."""

    def __init__(self, returns: pd.Series, rf_rate: float = 0.02):
        """
        Args:
            returns: Series of periodic returns
            rf_rate: Annual risk-free rate
        """
        self.returns = returns
        self.rf_rate = rf_rate
        self.ann_factor = 252  # Trading days per year

    # Volatility Metrics
    def volatility(self, annualized: bool = True) -> float:
        """Standard deviation of returns."""
        vol = self.returns.std()
        if annualized:
            vol *= np.sqrt(self.ann_factor)
        return vol

    def downside_deviation(self, threshold: float = 0, annualized: bool = True) -> float:
        """Standard deviation of returns below threshold."""
        downside = self.returns[self.returns < threshold]
        if len(downside) == 0:
            return 0.0
        dd = downside.std()
        if annualized:
            dd *= np.sqrt(self.ann_factor)
        return dd

    def beta(self, market_returns: pd.Series) -> float:
        """Beta relative to market."""
        aligned = pd.concat([self.returns, market_returns], axis=1).dropna()
        if len(aligned) < 2:
            return np.nan
        cov = np.cov(aligned.iloc[:, 0], aligned.iloc[:, 1])
        return cov[0, 1] / cov[1, 1] if cov[1, 1] != 0 else 0

    # Value at Risk
    def var_historical(self, confidence: float = 0.95) -> float:
        """Historical VaR at confidence level."""
        return -np.percentile(self.returns, (1 - confidence) * 100)

    def var_parametric(self, confidence: float = 0.95) -> float:
        """Parametric VaR assuming normal distribution."""
        z_score = stats.norm.ppf(confidence)
        return self.returns.mean() - z_score * self.returns.std()

    def var_cornish_fisher(self, confidence: float = 0.95) -> float:
        """VaR with Cornish-Fisher expansion for non-normality."""
        z = stats.norm.ppf(confidence)
        s = stats.skew(self.returns)  # Skewness
        k = stats.kurtosis(self.returns)  # Excess kurtosis

        # Cornish-Fisher expansion
        z_cf = (z + (z**2 - 1) * s / 6 +
                (z**3 - 3*z) * k / 24 -
                (2*z**3 - 5*z) * s**2 / 36)

        return -(self.returns.mean() + z_cf * self.returns.std())

    # Conditional VaR (Expected Shortfall)
    def cvar(self, confidence: float = 0.95) -> float:
        """Expected Shortfall / CVaR / Average VaR."""
        var = self.var_historical(confidence)
        return -self.returns[self.returns <= -var].mean()

    # Drawdown Analysis
    def drawdowns(self) -> pd.Series:
        """Calculate drawdown series."""
        cumulative = (1 + self.returns).cumprod()
        running_max = cumulative.cummax()
        return (cumulative - running_max) / running_max

    def max_drawdown(self) -> float:
        """Maximum drawdown."""
        return self.drawdowns().min()

    def avg_drawdown(self) -> float:
        """Average drawdown."""
        dd = self.drawdowns()
        return dd[dd < 0].mean() if (dd < 0).any() else 0

    def drawdown_duration(self) -> Dict[str, int]:
        """Drawdown duration statistics."""
        dd = self.drawdowns()
        in_drawdown = dd < 0

        # Find drawdown periods
        drawdown_starts = in_drawdown & ~in_drawdown.shift(1).fillna(False)
        drawdown_ends = ~in_drawdown & in_drawdown.shift(1).fillna(False)

        durations = []
        current_duration = 0

        for i in range(len(dd)):
            if in_drawdown.iloc[i]:
                current_duration += 1
            elif current_duration > 0:
                durations.append(current_duration)
                current_duration = 0

        if current_duration > 0:
            durations.append(current_duration)

        return {
            "max_duration": max(durations) if durations else 0,
            "avg_duration": np.mean(durations) if durations else 0,
            "current_duration": current_duration
        }

    # Risk-Adjusted Returns
    def sharpe_ratio(self) -> float:
        """Annualized Sharpe ratio."""
        excess_return = self.returns.mean() * self.ann_factor - self.rf_rate
        vol = self.volatility(annualized=True)
        return excess_return / vol if vol > 0 else 0

    def sortino_ratio(self) -> float:
        """Sortino ratio using downside deviation."""
        excess_return = self.returns.mean() * self.ann_factor - self.rf_rate
        dd = self.downside_deviation(threshold=0, annualized=True)
        return excess_return / dd if dd > 0 else 0

    def calmar_ratio(self) -> float:
        """Calmar ratio (return / max drawdown)."""
        annual_return = (1 + self.returns).prod() ** (self.ann_factor / len(self.returns)) - 1
        max_dd = abs(self.max_drawdown())
        return annual_return / max_dd if max_dd > 0 else 0

    def omega_ratio(self, threshold: float = 0) -> float:
        """Omega ratio."""
        returns_above = self.returns[self.returns > threshold] - threshold
        returns_below = threshold - self.returns[self.returns <= threshold]

        if returns_below.sum() == 0:
            return np.inf

        return returns_above.sum() / returns_below.sum()

    # Information Ratio
    def information_ratio(self, benchmark_returns: pd.Series) -> float:
        """Information ratio vs benchmark."""
        active_returns = self.returns - benchmark_returns
        tracking_error = active_returns.std() * np.sqrt(self.ann_factor)
        active_return = active_returns.mean() * self.ann_factor
        return active_return / tracking_error if tracking_error > 0 else 0

    # Summary
    def summary(self) -> Dict[str, float]:
        """Generate comprehensive risk summary."""
        dd_stats = self.drawdown_duration()

        return {
            # Returns
            "total_return": (1 + self.returns).prod() - 1,
            "annual_return": (1 + self.returns).prod() ** (self.ann_factor / len(self.returns)) - 1,

            # Volatility
            "annual_volatility": self.volatility(),
            "downside_deviation": self.downside_deviation(),

            # VaR & CVaR
            "var_95_historical": self.var_historical(0.95),
            "var_99_historical": self.var_historical(0.99),
            "cvar_95": self.cvar(0.95),

            # Drawdowns
            "max_drawdown": self.max_drawdown(),
            "avg_drawdown": self.avg_drawdown(),
            "max_drawdown_duration": dd_stats["max_duration"],

            # Risk-Adjusted
            "sharpe_ratio": self.sharpe_ratio(),
            "sortino_ratio": self.sortino_ratio(),
            "calmar_ratio": self.calmar_ratio(),
            "omega_ratio": self.omega_ratio(),

            # Distribution
            "skewness": stats.skew(self.returns),
            "kurtosis": stats.kurtosis(self.returns),
        }
```

### Pattern 2: Portfolio Risk

```python
class PortfolioRisk:
    """Portfolio-level risk calculations."""

    def __init__(
        self,
        returns: pd.DataFrame,
        weights: Optional[pd.Series] = None
    ):
        """
        Args:
            returns: DataFrame with asset returns (columns = assets)
            weights: Portfolio weights (default: equal weight)
        """
        self.returns = returns
        self.weights = weights if weights is not None else \
            pd.Series(1/len(returns.columns), index=returns.columns)
        self.ann_factor = 252

    def portfolio_return(self) -> float:
        """Weighted portfolio return."""
        return (self.returns @ self.weights).mean() * self.ann_factor

    def portfolio_volatility(self) -> float:
        """Portfolio volatility."""
        cov_matrix = self.returns.cov() * self.ann_factor
        port_var = self.weights @ cov_matrix @ self.weights
        return np.sqrt(port_var)

    def marginal_risk_contribution(self) -> pd.Series:
        """Marginal contribution to risk by asset."""
        cov_matrix = self.returns.cov() * self.ann_factor
        port_vol = self.portfolio_volatility()

        # Marginal contribution
        mrc = (cov_matrix @ self.weights) / port_vol
        return mrc

    def component_risk(self) -> pd.Series:
        """Component contribution to total risk."""
        mrc = self.marginal_risk_contribution()
        return self.weights * mrc

    def risk_parity_weights(self, target_vol: float = None) -> pd.Series:
        """Calculate risk parity weights."""
        from scipy.optimize import minimize

        n = len(self.returns.columns)
        cov_matrix = self.returns.cov() * self.ann_factor

        def risk_budget_objective(weights):
            port_vol = np.sqrt(weights @ cov_matrix @ weights)
            mrc = (cov_matrix @ weights) / port_vol
            rc = weights * mrc
            target_rc = port_vol / n  # Equal risk contribution
            return np.sum((rc - target_rc) ** 2)

        constraints = [
            {"type": "eq", "fun": lambda w: np.sum(w) - 1},  # Weights sum to 1
        ]
        bounds = [(0.01, 1.0) for _ in range(n)]  # Min 1%, max 100%
        x0 = np.array([1/n] * n)

        result = minimize(
            risk_budget_objective,
            x0,
            method="SLSQP",
            bounds=bounds,
            constraints=constraints
        )

        return pd.Series(result.x, index=self.returns.columns)

    def correlation_matrix(self) -> pd.DataFrame:
        """Asset correlation matrix."""
        return self.returns.corr()

    def diversification_ratio(self) -> float:
        """Diversification ratio (higher = more diversified)."""
        asset_vols = self.returns.std() * np.sqrt(self.ann_factor)
        weighted_vol = (self.weights * asset_vols).sum()
        port_vol = self.portfolio_volatility()
        return weighted_vol / port_vol if port_vol > 0 else 1

    def tracking_error(self, benchmark_returns: pd.Series) -> float:
        """Tracking error vs benchmark."""
        port_returns = self.returns @ self.weights
        active_returns = port_returns - benchmark_returns
        return active_returns.std() * np.sqrt(self.ann_factor)

    def conditional_correlation(
        self,
        threshold_percentile: float = 10
    ) -> pd.DataFrame:
        """Correlation during stress periods."""
        port_returns = self.returns @ self.weights
        threshold = np.percentile(port_returns, threshold_percentile)
        stress_mask = port_returns <= threshold
        return self.returns[stress_mask].corr()
```

### Pattern 3: Rolling Risk Metrics

```python
class RollingRiskMetrics:
    """Rolling window risk calculations."""

    def __init__(self, returns: pd.Series, window: int = 63):
        """
        Args:
            returns: Return series
            window: Rolling window size (default: 63 = ~3 months)
        """
        self.returns = returns
        self.window = window

    def rolling_volatility(self, annualized: bool = True) -> pd.Series:
        """Rolling volatility."""
        vol = self.returns.rolling(self.window).std()
        if annualized:
            vol *= np.sqrt(252)
        return vol

    def rolling_sharpe(self, rf_rate: float = 0.02) -> pd.Series:
        """Rolling Sharpe ratio."""
        rolling_return = self.returns.rolling(self.window).mean() * 252
        rolling_vol = self.rolling_volatility()
        return (rolling_return - rf_rate) / rolling_vol

    def rolling_var(self, confidence: float = 0.95) -> pd.Series:
        """Rolling historical VaR."""
        return self.returns.rolling(self.window).apply(
            lambda x: -np.percentile(x, (1 - confidence) * 100),
            raw=True
        )

    def rolling_max_drawdown(self) -> pd.Series:
        """Rolling maximum drawdown."""
        def max_dd(returns):
            cumulative = (1 + returns).cumprod()
            running_max = cumulative.cummax()
            drawdowns = (cumulative - running_max) / running_max
            return drawdowns.min()

        return self.returns.rolling(self.window).apply(max_dd, raw=False)

    def rolling_beta(self, market_returns: pd.Series) -> pd.Series:
        """Rolling beta vs market."""
        def calc_beta(window_data):
            port_ret = window_data.iloc[:, 0]
            mkt_ret = window_data.iloc[:, 1]
            cov = np.cov(port_ret, mkt_ret)
            return cov[0, 1] / cov[1, 1] if cov[1, 1] != 0 else 0

        combined = pd.concat([self.returns, market_returns], axis=1)
        return combined.rolling(self.window).apply(
            lambda x: calc_beta(x.to_frame()),
            raw=False
        ).iloc[:, 0]

    def volatility_regime(
        self,
        low_threshold: float = 0.10,
        high_threshold: float = 0.20
    ) -> pd.Series:
        """Classify volatility regime."""
        vol = self.rolling_volatility()

        def classify(v):
            if v < low_threshold:
                return "low"
            elif v > high_threshold:
                return "high"
            else:
                return "normal"

        return vol.apply(classify)
```

### Pattern 4: Stress Testing

```python
class StressTester:
    """Historical and hypothetical stress testing."""

    # Historical crisis periods
    HISTORICAL_SCENARIOS = {
        "2008_financial_crisis": ("2008-09-01", "2009-03-31"),
        "2020_covid_crash": ("2020-02-19", "2020-03-23"),
        "2022_rate_hikes": ("2022-01-01", "2022-10-31"),
        "dot_com_bust": ("2000-03-01", "2002-10-01"),
        "flash_crash_2010": ("2010-05-06", "2010-05-06"),
    }

    def __init__(self, returns: pd.Series, weights: pd.Series = None):
        self.returns = returns
        self.weights = weights

    def historical_stress_test(
        self,
        scenario_name: str,
        historical_data: pd.DataFrame
    ) -> Dict[str, float]:
        """Test portfolio against historical crisis period."""
        if scenario_name not in self.HISTORICAL_SCENARIOS:
            raise ValueError(f"Unknown scenario: {scenario_name}")

        start, end = self.HISTORICAL_SCENARIOS[scenario_name]

        # Get returns during crisis
        crisis_returns = historical_data.loc[start:end]

        if self.weights is not None:
            port_returns = (crisis_returns @ self.weights)
        else:
            port_returns = crisis_returns

        total_return = (1 + port_returns).prod() - 1
        max_dd = self._calculate_max_dd(port_returns)
        worst_day = port_returns.min()

        return {
            "scenario": scenario_name,
            "period": f"{start} to {end}",
            "total_return": total_return,
            "max_drawdown": max_dd,
            "worst_day": worst_day,
            "volatility": port_returns.std() * np.sqrt(252)
        }

    def hypothetical_stress_test(
        self,
        shocks: Dict[str, float]
    ) -> float:
        """
        Test portfolio against hypothetical shocks.

        Args:
            shocks: Dict of {asset: shock_return}
        """
        if self.weights is None:
            raise ValueError("Weights required for hypothetical stress test")

        total_impact = 0
        for asset, shock in shocks.items():
            if asset in self.weights.index:
                total_impact += self.weights[asset] * shock

        return total_impact

    def monte_carlo_stress(
        self,
        n_simulations: int = 10000,
        horizon_days: int = 21,
        vol_multiplier: float = 2.0
    ) -> Dict[str, float]:
        """Monte Carlo stress test with elevated volatility."""
        mean = self.returns.mean()
        vol = self.returns.std() * vol_multiplier

        simulations = np.random.normal(
            mean,
            vol,
            (n_simulations, horizon_days)
        )

        total_returns = (1 + simulations).prod(axis=1) - 1

        return {
            "expected_loss": -total_returns.mean(),
            "var_95": -np.percentile(total_returns, 5),
            "var_99": -np.percentile(total_returns, 1),
            "worst_case": -total_returns.min(),
            "prob_10pct_loss": (total_returns < -0.10).mean()
        }

    def _calculate_max_dd(self, returns: pd.Series) -> float:
        cumulative = (1 + returns).cumprod()
        running_max = cumulative.cummax()
        drawdowns = (cumulative - running_max) / running_max
        return drawdowns.min()
```

## Quick Reference

```python
# Daily usage
metrics = RiskMetrics(returns)
print(f"Sharpe: {metrics.sharpe_ratio():.2f}")
print(f"Max DD: {metrics.max_drawdown():.2%}")
print(f"VaR 95%: {metrics.var_historical(0.95):.2%}")

# Full summary
summary = metrics.summary()
for metric, value in summary.items():
    print(f"{metric}: {value:.4f}")
```

## Best Practices

### Do's

- **Use multiple metrics** - No single metric captures all risk
- **Consider tail risk** - VaR isn't enough, use CVaR
- **Rolling analysis** - Risk changes over time
- **Stress test** - Historical and hypothetical
- **Document assumptions** - Distribution, lookback, etc.

### Don'ts

- **Don't rely on VaR alone** - Underestimates tail risk
- **Don't assume normality** - Returns are fat-tailed
- **Don't ignore correlation** - Increases in stress
- **Don't use short lookbacks** - Miss regime changes
- **Don't forget transaction costs** - Affects realized risk

## Resources

- [Risk Management and Financial Institutions (John Hull)](https://www.amazon.com/Risk-Management-Financial-Institutions-5th/dp/1119448115)
- [Quantitative Risk Management (McNeil, Frey, Embrechts)](https://www.amazon.com/Quantitative-Risk-Management-Techniques-Princeton/dp/0691166277)
- [pyfolio Documentation](https://quantopian.github.io/pyfolio/)
